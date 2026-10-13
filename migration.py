# -*- coding: utf-8 -*-
r"""
EDUVERSE - Outil de migration PostgreSQL -> MySQL
Webtinix

Interface graphique simple : un bouton "Demarrer la migration".
Mode sans interface (tests, automatisation) :
    python3 migration.py --sans-interface [--oui] [--config chemin/config.ini]

Etapes automatiques :
  1. (Re)creation de la base MySQL  (DROP + CREATE DATABASE en utf8mb4)
  2. Chargement du schema EDUVERSE, partie 1 (tables, cles, AUTO_INCREMENT)
     + controle que MySQL accepte les procedures stockees
  3. Export de chaque table PostgreSQL en CSV (NULL ecrit NULL non quote,
     chaine vide ecrite vide ou "" : les deux restent distincts)
  4. Import dans MySQL via LOAD DATA LOCAL INFILE (ESCAPED BY '' : les
     antislashs sont conserves), avec conversions automatiques :
        - booleens PostgreSQL  t/f         -> 1/0
        - timestamptz                      -> heure locale du fuseau de l'application
        - bytea                            -> binaire (hexadecimal a l'export)
     Les avertissements MySQL (troncatures, dates invalides...) sont comptes.
  5. Verification des comptages source / cible
  6. Schema partie 2 : vues, fonctions, procedures, declencheurs
  7. Compteurs AUTO_INCREMENT alignes sur les sequences PostgreSQL
  8. Schema partie 3 : cles etrangeres (lignes orphelines signalees)
  9. Controle final des AUTO_INCREMENT

Un journal complet horodate est ecrit a cote du programme :
journal-migration-AAAAMMJJ-HHMM.txt (jamais de mot de passe dedans).

Fonctionne sous Windows et Linux.
Reglages : fichier  config.ini  (a cote de ce programme).
Schema   : fichier  schema_mysql.sql  (a cote de ce programme).
"""

import os
import re
import sys
import time
import shutil
import argparse
import datetime
import tempfile
import threading
import subprocess
import configparser

APP_TITLE = "EDUVERSE - Migration PostgreSQL vers MySQL"

# Reperes dans schema_mysql.sql
MARK_POST = "@@EDUVERSE-APRES-IMPORT@@"
MARK_FK = "@@EDUVERSE-CLES-ETRANGERES@@"
MARK_OBJ = "-- @@OBJET "

# Cles primaires qui ne sont PAS des compteurs dans RosarioSIS (valeur fournie
# par l'application) : jamais d'AUTO_INCREMENT.
NON_COUNTER_PK_TABLES = ("food_service_accounts", "food_service_staff_accounts",
                         "food_service_student_accounts", "history_marking_periods")

# Nombre maximum d'avertissements MySQL detailles par table dans le journal.
MAX_WARNINGS_DETAIL = 20


# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

def base_dir():
    """Dossier du programme (compatible avec PyInstaller)."""
    if getattr(sys, "frozen", False):
        return os.path.dirname(sys.executable)
    return os.path.dirname(os.path.abspath(__file__))


def default_config():
    # interpolation=None : un mot de passe contenant "%" ne doit pas provoquer d'erreur.
    cfg = configparser.ConfigParser(interpolation=None)
    is_win = sys.platform.startswith("win")
    cfg["postgres"] = {
        "psql": ((find_psql_windows() or r"C:\Program Files\PostgreSQL\17\bin\psql.exe")
                 if is_win else "psql"),
        "host": "localhost",
        "port": "5432",
        "user": "postgres",
        "password": "",
        "database": "eduverse",
    }
    cfg["mysql"] = {
        "mysql": (r"C:\xampp\mysql\bin\mysql.exe" if is_win else "/opt/lampp/bin/mysql"),
        "host": "localhost",
        "port": "3306",
        "user": "root",
        "password": "",
        "database": "eduverse_test",
        "schema_file": "schema_mysql.sql",
    }
    cfg["migration"] = {
        "fuseau_horaire": "",
    }
    return cfg


def load_config(path=None):
    if path is None:
        path = os.path.join(base_dir(), "config.ini")
    cfg = default_config()
    if os.path.exists(path):
        cfg.read(path, encoding="utf-8")
    else:
        with open(path, "w", encoding="utf-8") as f:
            cfg.write(f)
    return cfg, path


def schema_path(cfg, cfg_path=None):
    """Chemin du schema : absolu, sinon a cote de config.ini, sinon a cote du programme."""
    name = cfg["mysql"].get("schema_file", "schema_mysql.sql")
    if os.path.isabs(name):
        return name
    if cfg_path:
        candidate = os.path.join(os.path.dirname(os.path.abspath(cfg_path)), name)
        if os.path.exists(candidate):
            return candidate
    return os.path.join(base_dir(), name)


def is_windows():
    return sys.platform.startswith("win")


def find_psql_windows():
    """Cherche psql.exe dans C:\\Program Files\\PostgreSQL\\<version>\\bin (version la plus recente)."""
    import glob
    found = []
    for root in (os.environ.get("ProgramW6432"), os.environ.get("ProgramFiles"),
                 os.environ.get("ProgramFiles(x86)"), r"C:\Program Files"):
        if not root:
            continue
        for exe in glob.glob(os.path.join(root, "PostgreSQL", "*", "bin", "psql.exe")):
            ver = os.path.basename(os.path.dirname(os.path.dirname(exe)))
            try:
                key = tuple(int(x) for x in ver.split("."))
            except ValueError:
                key = (0,)
            found.append((key, exe))
    return max(found)[1] if found else None


def resolve_programs(cfg):
    """Sous Windows : si le psql de config.ini n'existe pas (ex. version 16 figee alors que
    la 17 est installee), prend la version installee la plus recente. Renvoie une note ou None."""
    if not is_windows():
        return None
    psql = cfg["postgres"].get("psql", "")
    if psql and os.path.isfile(psql):
        return None
    found = find_psql_windows()
    if found:
        cfg["postgres"]["psql"] = found
        return "psql de config.ini introuvable (%s) : utilisation de %s" % (psql, found)
    return None


def is_ascii(path):
    try:
        path.encode("ascii")
        return True
    except UnicodeEncodeError:
        return False


def make_work_dir():
    """Dossier temporaire des CSV. Son chemin doit etre en ASCII : psql.exe et mysql.exe
    ouvrent les fichiers avec la page de code Windows, un chemin accentue
    (C:\\Users\\Eleve accentue\\...) y serait illisible."""
    candidates = [tempfile.gettempdir()]
    if is_windows():
        candidates += [os.environ.get("PUBLIC", ""), os.environ.get("ProgramData", ""), r"C:\Temp"]
    candidates.append(base_dir())
    for folder in candidates:
        if not folder or not is_ascii(folder):
            continue
        try:
            os.makedirs(folder, exist_ok=True)
            return tempfile.mkdtemp(prefix="eduverse_csv_", dir=folder)
        except OSError:
            continue
    raise RuntimeError("Aucun dossier temporaire au chemin sans accent n'est accessible en ecriture.")


# ---------------------------------------------------------------------------
# Journal (fichier a cote du programme + fenetre / console)
# ---------------------------------------------------------------------------

def journal_folders():
    """A cote du programme (.exe), sinon %LOCALAPPDATA%\\EDUVERSE-Migration, sinon dossier perso / temp."""
    folders = [base_dir()]
    if os.environ.get("LOCALAPPDATA"):
        folders.append(os.path.join(os.environ["LOCALAPPDATA"], "EDUVERSE-Migration"))
    folders += [os.path.expanduser("~"), tempfile.gettempdir()]
    return folders


class Journal:
    """Ecrit chaque ligne, horodatee, dans un fichier ; la transmet a l'affichage.
    Aucun mot de passe n'y est jamais ecrit."""

    def __init__(self, display=None):
        self.display = display
        stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M")
        self.path = None
        self.fh = None
        self.fallback_note = None
        for folder in journal_folders():
            path = os.path.join(folder, "journal-migration-%s.txt" % stamp)
            if os.path.exists(path):
                path = os.path.join(folder, "journal-migration-%s.txt"
                                    % datetime.datetime.now().strftime("%Y%m%d-%H%M%S"))
            try:
                os.makedirs(folder, exist_ok=True)
                self.fh = open(path, "a", encoding="utf-8")
                self.path = path
                if folder != base_dir():
                    self.fallback_note = ("Dossier du programme non accessible en ecriture : "
                                          "journal ecrit dans %s" % folder)
                break
            except OSError:
                continue

    def write(self, msg, to_display=True):
        if self.fh:
            now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            for line in str(msg).split("\n"):
                self.fh.write("[%s] %s\n" % (now, line))
            self.fh.flush()
        if to_display and self.display:
            self.display(msg)

    def detail(self, msg):
        """Ligne ecrite seulement dans le fichier (details volumineux)."""
        self.write(msg, to_display=False)

    def close(self):
        if self.fh:
            self.fh.close()
            self.fh = None


# ---------------------------------------------------------------------------
# Lancement de commandes psql / mysql
# ---------------------------------------------------------------------------

def run(cmd, env=None, stdin_path=None):
    """Lance une commande, renvoie (code, sortie_texte). stdin_path = fichier a injecter en entree."""
    full_env = os.environ.copy()
    if env:
        full_env.update(env)
    stdin = open(stdin_path, "rb") if stdin_path else subprocess.DEVNULL
    kwargs = {}
    if sys.platform.startswith("win"):
        # Pas de fenetre noire qui clignote a chaque commande sous Windows.
        kwargs["creationflags"] = getattr(subprocess, "CREATE_NO_WINDOW", 0)
    try:
        proc = subprocess.run(
            cmd, env=full_env, stdin=stdin,
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            text=True, encoding="utf-8", errors="replace", **kwargs
        )
    except FileNotFoundError:
        raise RuntimeError("Programme introuvable : %s\n(verifier le chemin dans config.ini)" % cmd[0])
    except OSError as e:
        raise RuntimeError("Programme impossible a lancer : %s\n%s\n(verifier le chemin dans config.ini)"
                           % (cmd[0], e))
    finally:
        if stdin_path:
            stdin.close()
    return proc.returncode, (proc.stdout or "")


def clean_output(out):
    """Retire les messages parasites des clients (avertissements sans importance)."""
    lines = []
    for line in out.splitlines():
        if "No existing cluster is suitable" in line or "man pg_wrapper" in line:
            continue
        if "Using a password on the command line" in line:
            continue
        lines.append(line)
    return "\n".join(lines)


def pg_env(cfg, tz=None):
    env = {"PGPASSWORD": cfg["postgres"]["password"],
           "PGCONNECT_TIMEOUT": "15",
           "PGCLIENTENCODING": "UTF8",
           "PGDATESTYLE": "ISO, YMD"}
    if tz:
        env["PGTZ"] = tz
    return env


def mysql_env(cfg):
    return {"MYSQL_PWD": cfg["mysql"]["password"]}


def pg_base(cfg):
    p = cfg["postgres"]
    # -w : ne jamais demander de mot de passe. Sous Windows, sans console, psql
    # attendait une saisie impossible et le programme restait bloque.
    return [p["psql"], "-X", "-w", "-v", "ON_ERROR_STOP=1", "-h", p["host"], "-p", p["port"],
            "-U", p["user"], "-d", p["database"]]


def mysql_base(cfg, with_db=True):
    m = cfg["mysql"]
    cmd = [m["mysql"], "--local-infile=1", "--default-character-set=utf8mb4", "--connect-timeout=15",
           "-h", m["host"], "-P", m["port"], "-u", m["user"]]
    if with_db:
        cmd.append(m["database"])
    return cmd


def pg_query(cfg, sql, tz=None):
    """Requete PostgreSQL -> liste de lignes (colonnes separees par |)."""
    code, out = run(pg_base(cfg) + ["-t", "-A", "-F", "|", "-c", sql], pg_env(cfg, tz))
    if code != 0:
        raise RuntimeError("Requete PostgreSQL en echec :\n%s" % clean_output(out))
    return [l for l in clean_output(out).splitlines() if l.strip()]


def mysql_query(cfg, sql, with_db=True):
    """Requete MySQL -> liste de lignes (colonnes separees par tabulation)."""
    code, out = run(mysql_base(cfg, with_db) + ["-N", "-B", "-e", sql], mysql_env(cfg))
    if code != 0:
        raise RuntimeError("Requete MySQL en echec :\n%s" % clean_output(out))
    return [l for l in clean_output(out).splitlines() if l != ""]


def q_ident_my(name):
    return "`%s`" % name.replace("`", "``")


def q_ident_pg(name):
    return '"%s"' % name.replace('"', '""')


def sql_str(value):
    return "'%s'" % value.replace("\\", "\\\\").replace("'", "''")


# ---------------------------------------------------------------------------
# PostgreSQL : liste des tables, schema des colonnes, comptages
# ---------------------------------------------------------------------------

def list_tables(cfg):
    code, out = run(pg_base(cfg) + ["-t", "-A", "-c",
                    "SELECT tablename FROM pg_tables WHERE schemaname='public' ORDER BY tablename;"],
                    pg_env(cfg))
    if code != 0:
        msg = clean_output(out)
        if "password" in msg.lower() or "mot de passe" in msg.lower():
            msg += ("\n\n-> Verifier le mot de passe PostgreSQL dans config.ini "
                    "(section [postgres], ligne password =).")
        elif "timeout" in msg.lower() or "could not connect" in msg.lower() or "connexion" in msg.lower():
            msg += ("\n\n-> Verifier que PostgreSQL est demarre, et l'adresse et le port "
                    "dans config.ini (section [postgres]).")
        raise RuntimeError("Connexion PostgreSQL impossible :\n" + msg)
    return [t.strip() for t in clean_output(out).splitlines() if t.strip()]


def get_all_pg_schemas(cfg):
    """{table: [(colonne, type_udt, nullable_bool), ...]} dans l'ordre des colonnes."""
    rows = pg_query(cfg, "SELECT table_name, column_name, udt_name, is_nullable "
                         "FROM information_schema.columns WHERE table_schema='public' "
                         "ORDER BY table_name, ordinal_position;")
    res = {}
    for line in rows:
        parts = line.split("|")
        if len(parts) >= 4:
            res.setdefault(parts[0], []).append(
                (parts[1], parts[2].lower(), parts[3].strip().upper() == "YES"))
    return res


def pg_count(cfg, table):
    code, out = run(pg_base(cfg) + ["-t", "-A", "-c", "SELECT COUNT(*) FROM public.%s;" % q_ident_pg(table)],
                    pg_env(cfg))
    return clean_output(out).strip() if code == 0 else "?"


def mysql_count(cfg, table):
    code, out = run(mysql_base(cfg) + ["-N", "-B", "-e", "SELECT COUNT(*) FROM %s;" % q_ident_my(table)],
                    mysql_env(cfg))
    return clean_output(out).strip() if code == 0 else "?"


def resolve_timezone(cfg):
    """Fuseau de l'application : config.ini [migration] fuseau_horaire, sinon celui du serveur PG.
    Renvoie (nom, decalage_mysql '+01:00')."""
    tz = cfg["migration"].get("fuseau_horaire", "").strip() if cfg.has_section("migration") else ""
    if not tz:
        tz = pg_query(cfg, "SHOW timezone;")[0].strip()
    off = pg_query(cfg, "SELECT to_char(now(), 'OF');", tz=tz)[0].strip()
    if re.match(r"^[+-]\d{2}$", off):
        off += ":00"
    if not re.match(r"^[+-]\d{2}:\d{2}$", off):
        raise RuntimeError("Fuseau horaire '%s' : decalage illisible (%s)" % (tz, off))
    return tz, off


# ---------------------------------------------------------------------------
# Categorisation des types PostgreSQL -> regle de conversion
# ---------------------------------------------------------------------------

MYSQL_STRING_TYPES = {"char", "varchar", "tinytext", "text", "mediumtext", "longtext",
                      "enum", "set", "json"}


def column_category(udt):
    if udt == "bool":
        return "bool"
    if udt in ("int2", "int4", "int8", "numeric", "float4", "float8", "money"):
        return "num"
    if udt == "date":
        return "date"
    if udt == "timestamp":
        return "datetime"
    if udt == "timestamptz":
        return "timestamptz"
    if udt == "time":
        return "time"
    if udt == "timetz":
        return "timetz"
    if udt == "bytea":
        return "bytea"
    if udt.startswith("_"):
        return "array"
    return "str"


# ---------------------------------------------------------------------------
# Export / Import d'une table
# ---------------------------------------------------------------------------

def export_select(table, schema):
    """SELECT d'export : timestamptz rendu dans le fuseau de la session (PGTZ), sans decalage."""
    exprs = []
    for name, udt, _nullable in schema:
        col = q_ident_pg(name)
        cat = column_category(udt)
        if cat == "timestamptz":
            exprs.append("to_char(%s, 'YYYY-MM-DD HH24:MI:SS.US') AS %s" % (col, col))
        elif cat == "timetz":
            exprs.append("%s::time AS %s" % (col, col))
        elif cat == "bytea":
            exprs.append("encode(%s, 'hex') AS %s" % (col, col))
        else:
            exprs.append(col)
    return "SELECT %s FROM public.%s" % (", ".join(exprs), q_ident_pg(table))


def export_table(cfg, table, schema, csv_dir, tz):
    csv_path = os.path.join(csv_dir, table + ".csv")
    target = csv_path.replace("\\", "/").replace("'", "''")
    # NULL 'NULL' : un NULL est ecrit NULL sans guillemets ; une vraie chaine "NULL"
    # est entouree de guillemets par PostgreSQL ; MySQL fait la meme distinction.
    sql = ("\\copy (%s) TO '%s' WITH (FORMAT csv, HEADER true, NULL 'NULL', ENCODING 'UTF8')"
           % (export_select(table, schema), target))
    code, out = run(pg_base(cfg) + ["-c", sql], pg_env(cfg, tz))
    if code != 0:
        raise RuntimeError("Export de '%s' echoue :\n%s" % (table, clean_output(out)))
    return csv_path


def csv_line_terminator(csv_path):
    with open(csv_path, "rb") as f:
        first = f.readline()
    return "\\r\\n" if first.endswith(b"\r\n") else "\\n"


def build_load_sql(table, schema, csv_path, mysql_cols, tz_offset):
    """Construit la requete LOAD DATA avec les conversions deduites des types PG.

    mysql_cols : {nom_colonne_minuscule: (type_mysql, nullable)} de la table MySQL.
    Une colonne PostgreSQL absente de MySQL est lue puis ignoree (signalee)."""
    csv_unix = csv_path.replace("\\", "/")
    col_clause = []
    set_parts = []
    for i, (name, udt, _nullable) in enumerate(schema):
        var = "@c%d" % i
        col_clause.append(var)
        if name.lower() not in mysql_cols:
            continue
        my_type, my_nullable = mysql_cols[name.lower()]
        cat = column_category(udt)
        col_q = q_ident_my(name)
        if cat == "bool":
            set_parts.append(
                "%s = IF(%s IN ('t','true','TRUE','1'),1,"
                "IF(%s IN ('f','false','FALSE','0'),0,NULL))" % (col_q, var, var))
        elif cat == "bytea":
            set_parts.append("%s = UNHEX(%s)" % (col_q, var))
        elif cat in ("str", "array") and my_type not in MYSQL_STRING_TYPES and my_nullable:
            # Texte PG vers colonne MySQL non textuelle : une chaine vide n'y a pas
            # d'equivalent ; NULL plutot que 0 / 0000-00-00.
            set_parts.append("%s = NULLIF(%s,'')" % (col_q, var))
        else:
            set_parts.append("%s = %s" % (col_q, var))

    sql = (
        "SET SESSION sql_mode = 'NO_AUTO_VALUE_ON_ZERO';\n"
        "SET SESSION max_error_count = 65535;\n"
        "SET SESSION time_zone = '%s';\n"
        "SET FOREIGN_KEY_CHECKS = 0;\n"
        "LOAD DATA LOCAL INFILE %s\n"
        "INTO TABLE %s\n"
        "CHARACTER SET utf8mb4\n"
        "FIELDS TERMINATED BY ',' ENCLOSED BY '\"' ESCAPED BY ''\n"
        "LINES TERMINATED BY '%s'\n"
        "IGNORE 1 LINES\n"
        "(%s)" % (tz_offset, sql_str(csv_unix), q_ident_my(table),
                  csv_line_terminator(csv_path), ", ".join(col_clause))
    )
    if set_parts:
        sql += "\nSET " + ",\n    ".join(set_parts)
    # Meme session : le nombre et le detail des avertissements de LOAD DATA.
    sql += ";\nSHOW COUNT(*) WARNINGS;\nSHOW WARNINGS;"
    return sql


def mask_values(msg):
    """Masque les valeurs citees dans un avertissement MySQL (donnees personnelles)."""
    return re.sub(r"value: '.*?' for", "value: '***' for", msg)


def import_table(cfg, table, schema, csv_path, mysql_cols, tz_offset):
    """Importe une table. Renvoie (colonnes_pg_ignorees, nb_avertissements, [avertissements])."""
    sql = build_load_sql(table, schema, csv_path, mysql_cols, tz_offset)
    code, out = run(mysql_base(cfg) + ["-N", "-B", "-e", sql], mysql_env(cfg))
    out = clean_output(out)
    if code != 0:
        raise RuntimeError("Import de '%s' echoue :\n%s" % (table, out))
    lines = [l for l in out.splitlines() if l.strip()]
    n_warn = 0
    details = []
    if lines and lines[0].strip().isdigit():
        n_warn = int(lines[0].strip())
        details = [mask_values(l.replace("\t", " ")) for l in lines[1:]]
    extra = [n for (n, _u, _nu) in schema if n.lower() not in mysql_cols]
    return extra, n_warn, details


# ---------------------------------------------------------------------------
# Creation de la base + chargement du schema
# ---------------------------------------------------------------------------

def recreate_database(cfg):
    db = cfg["mysql"]["database"]
    sql = ("DROP DATABASE IF EXISTS %s; "
           "CREATE DATABASE %s CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
           % (q_ident_my(db), q_ident_my(db)))
    code, out = run(mysql_base(cfg, with_db=False) + ["-e", sql], mysql_env(cfg))
    if code != 0:
        msg = clean_output(out)
        bas = msg.lower()
        if "access denied" in bas:
            msg += ("\n\n-> Verifier l'utilisateur et le mot de passe MySQL dans config.ini "
                    "(section [mysql]).")
        elif "can't connect" in bas or "timeout" in bas or "2002" in msg or "2003" in msg:
            msg += ("\n\n-> Verifier que MySQL est demarre (XAMPP : bouton Start de MySQL), "
                    "et l'adresse et le port dans config.ini (section [mysql]).")
        raise RuntimeError("Connexion MySQL impossible :\n" + msg)


def _line_start_before(text, idx):
    """Debut de la ligne precedant celle qui contient idx (le cadre '-- ####')."""
    return text.rfind("\n", 0, text.rfind("\n", 0, idx)) + 1


def split_schema(path):
    """Decoupe schema_mysql.sql : (partie_tables, [(type, nom, sql)], [instructions_cles_etrangeres])."""
    with open(path, encoding="utf-8") as f:
        text = f.read()
    m_post = re.search(r"^-- %s[ \t]*$" % re.escape(MARK_POST), text, re.M)
    idx_post = m_post.start() + 1 if m_post else -1
    if idx_post < 0:
        return text, [], []
    start_post = _line_start_before(text, idx_post)
    part1 = text[:start_post]
    rest = text[start_post:]
    m_fk = re.search(r"^-- %s[ \t]*$" % re.escape(MARK_FK), rest, re.M)
    idx_fk = m_fk.start() + 1 if m_fk else -1
    if idx_fk >= 0:
        start_fk = _line_start_before(rest, idx_fk)
        part2, part3 = rest[:start_fk], rest[start_fk:]
    else:
        part2, part3 = rest, ""
    objects = []
    current = None
    for line in part2.splitlines(True):
        if line.startswith(MARK_OBJ):
            words = line[len(MARK_OBJ):].split()
            current = [words[0], words[1] if len(words) > 1 else "?", ""]
            objects.append(current)
        elif current is not None:
            current[2] += line
    fks = [l.strip() for l in part3.splitlines()
           if l.startswith("ALTER TABLE") and "FOREIGN KEY" in l]
    return part1, [tuple(o) for o in objects], fks


def load_sql_text(cfg, sql_text, tmp_dir, name="bloc.sql"):
    """Passe un texte SQL au client mysql (gere DELIMITER). Renvoie (code, sortie)."""
    path = os.path.join(tmp_dir, name)
    with open(path, "w", encoding="utf-8") as f:
        f.write(sql_text)
    try:
        return run(mysql_base(cfg), mysql_env(cfg), stdin_path=path)
    finally:
        os.remove(path)


ROUTINE_HELP = (
    "MySQL refuse la creation de procedures stockees :\n%s\n\n"
    "Cause habituelle sous XAMPP : MariaDB a ete mis a jour sans mettre a jour\n"
    "ses tables systeme (erreur 1558 ou 1805 'Column count of mysql.proc is wrong').\n"
    "REPARATION (une seule fois) :\n"
    "  1. Demarrer MySQL dans le panneau XAMPP.\n"
    "  2. Windows : C:\\xampp\\mysql\\bin\\mysql_upgrade.exe -u root -p\n"
    "     Linux   : sudo /opt/lampp/bin/mysql_upgrade -u root -p\n"
    "  3. Redemarrer MySQL dans le panneau XAMPP, puis relancer la migration.\n"
    "Sans cette reparation, les moyennes / rangs (declencheurs) et la fonction\n"
    "credit() n'existeraient pas : la migration est arretee avant l'import."
)


def check_routines_supported(cfg, tmp_dir):
    """Cree puis supprime une procedure de test. Leve une erreur claire si impossible."""
    sql = ("DROP PROCEDURE IF EXISTS eduverse_test_migration;\n"
           "DELIMITER $$\nCREATE PROCEDURE eduverse_test_migration() BEGIN END$$\nDELIMITER ;\n"
           "DROP PROCEDURE eduverse_test_migration;\n")
    code, out = load_sql_text(cfg, sql, tmp_dir, "test_routine.sql")
    if code != 0:
        raise RuntimeError(ROUTINE_HELP % clean_output(out).strip())


def mysql_tables(cfg):
    code, out = run(mysql_base(cfg) + ["-N", "-B", "-e", "SHOW FULL TABLES WHERE Table_type='BASE TABLE';"],
                    mysql_env(cfg))
    if code != 0:
        raise RuntimeError("Lecture des tables MySQL impossible :\n" + clean_output(out))
    return {t.split("\t")[0].strip() for t in clean_output(out).splitlines() if t.strip()}


def get_all_mysql_columns(cfg):
    """{table: {colonne_minuscule: (type, nullable)}}"""
    rows = mysql_query(cfg, "SELECT table_name, column_name, data_type, is_nullable "
                            "FROM information_schema.columns WHERE table_schema = DATABASE();")
    res = {}
    for line in rows:
        parts = line.split("\t")
        if len(parts) >= 4:
            res.setdefault(parts[0], {})[parts[1].lower()] = (parts[2].lower(), parts[3] == "YES")
    return res


# ---------------------------------------------------------------------------
# Apres import : sequences, cles etrangeres, controles
# ---------------------------------------------------------------------------

def sync_auto_increment(cfg, journal):
    """AUTO_INCREMENT MySQL >= derniere valeur de la sequence PostgreSQL + 1
    (evite de reattribuer des identifiants supprimes cote PostgreSQL)."""
    rows = pg_query(cfg, "SELECT c.table_name, c.column_name, "
                         "COALESCE(pg_get_serial_sequence(quote_ident(c.table_name), c.column_name), "
                         "substring(c.column_default from 'nextval\\(''([^'']+)''')) "
                         "FROM information_schema.columns c JOIN pg_tables t "
                         "ON t.schemaname='public' AND t.tablename=c.table_name "
                         "WHERE c.table_schema='public' AND (c.column_default LIKE 'nextval(%' "
                         "OR c.is_identity='YES');")
    seqs = []
    for line in rows:
        parts = line.split("|")
        if len(parts) == 3 and parts[2]:
            seqs.append(parts)
    if not seqs:
        return 0
    union = " UNION ALL ".join(
        "SELECT '%s', '%s', (SELECT CASE WHEN is_called THEN last_value ELSE last_value - 1 END FROM %s)"
        % (t.replace("'", "''"), c.replace("'", "''"), s) for t, c, s in seqs)
    values = pg_query(cfg, union + ";")
    ai_cols = set()
    for r in mysql_query(cfg, "SELECT table_name, column_name FROM information_schema.columns "
                              "WHERE table_schema = DATABASE() AND extra LIKE '%auto_increment%';"):
        t, c = r.split("\t")
        ai_cols.add((t, c.lower()))
    stmts = []
    for line in values:
        t, c, v = line.split("|")
        if (t, c.lower()) in ai_cols and v.strip().lstrip("-").isdigit():
            stmts.append("ALTER TABLE %s AUTO_INCREMENT = %d;" % (q_ident_my(t), max(int(v), 0) + 1))
    if stmts:
        mysql_query(cfg, "\n".join(stmts))
    journal.detail("   Compteurs AUTO_INCREMENT alignes sur %d sequences PostgreSQL." % len(stmts))
    return len(stmts)


FK_RE = re.compile(r"ALTER TABLE `([^`]+)` ADD CONSTRAINT `([^`]+)` FOREIGN KEY \(([^)]*)\) "
                   r"REFERENCES `([^`]+)` \(([^)]*)\)")


def add_foreign_keys(cfg, fks, tables_present):
    """Pose les cles etrangeres une par une, apres comptage des lignes orphelines.
    Renvoie (nb_posees, [problemes])."""
    added = 0
    problems = []
    parsed = []
    for stmt in fks:
        m = FK_RE.match(stmt)
        if not m:
            problems.append("instruction illisible : %s" % stmt[:80])
            continue
        child, name, ccols, parent, pcols = m.groups()
        ccols = [c.strip(" `") for c in ccols.split(",")]
        pcols = [c.strip(" `") for c in pcols.split(",")]
        if child not in tables_present or parent not in tables_present:
            problems.append("table %s, contrainte %s : table absente, cle non posee" % (child, name))
            continue
        parsed.append((stmt, child, name, ccols, parent, pcols))
    if not parsed:
        return added, problems
    # Comptage des orphelins : une seule connexion pour toutes les cles.
    selects = []
    for i, (_s, child, _name, ccols, parent, pcols) in enumerate(parsed):
        notnull = " AND ".join("c.%s IS NOT NULL" % q_ident_my(c) for c in ccols)
        join = " AND ".join("p.%s = c.%s" % (q_ident_my(p), q_ident_my(c)) for p, c in zip(pcols, ccols))
        selects.append("SELECT %d, COUNT(*) FROM %s c WHERE %s AND NOT EXISTS "
                       "(SELECT 1 FROM %s p WHERE %s);"
                       % (i, q_ident_my(child), notnull, q_ident_my(parent), join))
    orphans = {}
    for line in mysql_query(cfg, "\n".join(selects)):
        i, n = line.split("\t")
        orphans[int(i)] = int(n)
    for i, (stmt, child, name, ccols, parent, _pcols) in enumerate(parsed):
        n = orphans.get(i, -1)
        if n != 0:
            problems.append("table %s, contrainte %s (%s -> %s) : %s ligne(s) orpheline(s), cle NON posee"
                            % (child, name, ",".join(ccols), parent, n if n >= 0 else "?"))
            continue
        code, out = run(mysql_base(cfg) + ["-e", "SET FOREIGN_KEY_CHECKS = 1; " + stmt], mysql_env(cfg))
        if code != 0:
            problems.append("table %s, contrainte %s : echec %s" % (child, name, clean_output(out).strip()))
        else:
            added += 1
    return added, problems


def missing_auto_increment(cfg):
    """Cles primaires mono-colonne entieres sans AUTO_INCREMENT (hors non-compteurs)."""
    excluded = ",".join("'%s'" % t for t in NON_COUNTER_PK_TABLES)
    return mysql_query(cfg, (
        "SELECT CONCAT(c.table_name, '.', c.column_name) FROM information_schema.columns c "
        "JOIN information_schema.tables t ON t.table_schema=c.table_schema AND t.table_name=c.table_name "
        "AND t.table_type='BASE TABLE' "
        "WHERE c.table_schema = DATABASE() AND c.column_key = 'PRI' "
        "AND c.data_type IN ('tinyint','smallint','mediumint','int','bigint') "
        "AND c.extra NOT LIKE '%%auto_increment%%' AND c.table_name NOT IN (%s) "
        "AND (SELECT COUNT(*) FROM information_schema.key_column_usage k "
        "WHERE k.table_schema=c.table_schema AND k.table_name=c.table_name "
        "AND k.constraint_name='PRIMARY') = 1 ORDER BY 1;") % excluded)


# ---------------------------------------------------------------------------
# Deroulement complet (commun a l'interface et au mode sans interface)
# ---------------------------------------------------------------------------

class Migration:
    """Execute toutes les etapes. status(msg) et progress(val, max) sont des rappels d'affichage."""

    def __init__(self, cfg, cfg_path, journal, status=None, progress=None):
        self.cfg = cfg
        self.cfg_path = cfg_path
        self.j = journal
        self.status = status or (lambda *a: None)
        self.progress = progress or (lambda *a: None)

    def log(self, msg):
        self.j.write(msg)

    def run(self):
        """Renvoie (niveau, message) ; niveau = 'ok' | 'attention'. Leve une exception si echec."""
        cfg = self.cfg
        t0 = time.time()
        warnings_total = 0
        warn_tables = []
        ignored_cols = []
        alerts = []

        self.log("Journal : %s" % self.j.path)
        if self.j.fallback_note:
            self.log(self.j.fallback_note)
        self.j.detail("Source PostgreSQL : base %s sur %s:%s (utilisateur %s)"
                      % (cfg["postgres"]["database"], cfg["postgres"]["host"],
                         cfg["postgres"]["port"], cfg["postgres"]["user"]))
        self.j.detail("Cible MySQL : base %s sur %s:%s (utilisateur %s)"
                      % (cfg["mysql"]["database"], cfg["mysql"]["host"],
                         cfg["mysql"]["port"], cfg["mysql"]["user"]))
        spath = schema_path(cfg, self.cfg_path)
        self.j.detail("Schema : %s" % spath)
        if not os.path.exists(spath):
            raise RuntimeError("Fichier de schema introuvable : %s" % spath)
        part1, objects, fks = split_schema(spath)
        if not objects and not fks:
            alerts.append("schema_mysql.sql ancien : ni vues, ni fonctions, ni cles etrangeres.")

        note = resolve_programs(cfg)
        if note:
            self.log(note)

        # 0) Connexion + liste des tables PostgreSQL
        self.status("Connexion a PostgreSQL...")
        self.log(">> Lecture des tables PostgreSQL...")
        tables = list_tables(cfg)
        if not tables:
            raise RuntimeError("Aucune table trouvee dans le schema 'public'.")
        self.log("   %d tables detectees." % len(tables))
        tz_name, tz_off = resolve_timezone(cfg)
        self.log("   Fuseau horaire de l'application : %s (UTC%s)" % (tz_name, tz_off))

        total = len(tables)
        steps_max = total * 2 + 6
        self.progress(0, steps_max)
        step = 0

        tmp_dir = make_work_dir()
        self.j.detail("Dossier temporaire des CSV : %s" % tmp_dir)
        try:
            # 1) Recreation de la base
            self.status("Creation de la base MySQL...")
            self.log(">> (Re)creation de la base MySQL...")
            recreate_database(cfg)
            step += 1
            self.progress(step)

            # 2) Chargement du schema (partie 1 : tables)
            self.status("Chargement du schema EDUVERSE...")
            self.log(">> Chargement du schema (tables, cles, AUTO_INCREMENT)...")
            code, out = load_sql_text(cfg, part1, tmp_dir, "schema_tables.sql")
            if code != 0:
                raise RuntimeError("Chargement du schema echoue :\n" + clean_output(out))
            mtabs = mysql_tables(cfg)
            self.log("   %d tables creees dans MySQL." % len(mtabs))
            if not mtabs:
                raise RuntimeError("Le schema n'a cree aucune table : verifier %s" % spath)
            if objects:
                self.log(">> Controle : MySQL accepte-t-il les procedures stockees ?")
                check_routines_supported(cfg, tmp_dir)
                self.log("   Oui.")
            step += 1
            self.progress(step)

            missing = [t for t in tables if t not in mtabs]
            if missing:
                self.log("   [INFO] Tables PG absentes du schema MySQL (ignorees) : %s"
                         % ", ".join(missing))
            todo = [t for t in tables if t in mtabs]
            mysql_cols = get_all_mysql_columns(cfg)
            pg_schemas = get_all_pg_schemas(cfg)

            # 3) Export CSV
            for t in todo:
                self.status("Export de %s..." % t)
                self.log(">> Export   : %s" % t)
                export_table(cfg, t, pg_schemas[t], tmp_dir, tz_name)
                step += 1
                self.progress(step)

            # 4) Import
            for t in todo:
                self.status("Import de %s..." % t)
                csv_path = os.path.join(tmp_dir, t + ".csv")
                extra, n_warn, details = import_table(cfg, t, pg_schemas[t], csv_path,
                                                      mysql_cols.get(t, {}), tz_off)
                os.remove(csv_path)
                if n_warn:
                    self.log(">> Import   : %s   [%d avertissement(s) MySQL]" % (t, n_warn))
                    warnings_total += n_warn
                    warn_tables.append((t, n_warn))
                    for d in details[:MAX_WARNINGS_DETAIL]:
                        self.j.detail("     %s" % d)
                    if n_warn > MAX_WARNINGS_DETAIL:
                        self.j.detail("     ... (%d autres)" % (n_warn - MAX_WARNINGS_DETAIL))
                else:
                    self.log(">> Import   : %s" % t)
                if extra:
                    ignored_cols.extend("%s.%s" % (t, c) for c in extra)
                    self.log("     (colonnes PG ignorees, absentes de MySQL : %s)" % ", ".join(extra))
                step += 1
                self.progress(step)

            # 5) Verification des comptages
            self.status("Verification des comptages...")
            self.log("\n=== Verification (lignes PostgreSQL -> MySQL) ===")
            problems = 0
            for t in todo:
                s = pg_count(cfg, t)
                d = mysql_count(cfg, t)
                ok = (s == d and s != "?")
                if not ok:
                    problems += 1
                self.log("   %-34s  %7s -> %7s   %s" % (t, s, d, "OK" if ok else "!! DIFFERENCE"))
            step += 1
            self.progress(step)

            # 6) Vues, fonctions, procedures, declencheurs (apres l'import : sinon les
            #    declencheurs recalculeraient student_mp_stats pendant l'import)
            obj_fail = []
            if objects:
                self.status("Creation des vues, fonctions et declencheurs...")
                self.log("\n>> Vues, fonctions, procedures, declencheurs (%d objets)..." % len(objects))
                for kind, name, sql in objects:
                    code, out = load_sql_text(cfg, sql, tmp_dir, "objet.sql")
                    if code != 0:
                        msg = clean_output(out).strip()
                        if "1418" in msg:
                            msg += ("\n     (journalisation binaire active : executer une fois "
                                    "SET GLOBAL log_bin_trust_function_creators = 1;)")
                        obj_fail.append("%s %s" % (kind, name))
                        self.log("   [ECHEC] %s %s : %s" % (kind, name, msg))
                    else:
                        self.j.detail("   %s %s : cree" % (kind, name))
                self.log("   %d / %d objets crees." % (len(objects) - len(obj_fail), len(objects)))
            step += 1
            self.progress(step)

            # 7) Compteurs AUTO_INCREMENT
            self.status("Alignement des compteurs...")
            self.log(">> Compteurs AUTO_INCREMENT alignes sur les sequences PostgreSQL...")
            n_seq = sync_auto_increment(cfg, self.j)
            self.log("   %d compteurs." % n_seq)
            step += 1
            self.progress(step)

            # 8) Cles etrangeres
            fk_problems = []
            if fks:
                self.status("Pose des cles etrangeres...")
                self.log(">> Cles etrangeres (%d)..." % len(fks))
                added, fk_problems = add_foreign_keys(cfg, fks, mysql_tables(cfg))
                self.log("   %d / %d cles posees." % (added, len(fks)))
                for p in fk_problems:
                    self.log("   [ATTENTION] %s" % p)
            step += 1
            self.progress(step)

            # 9) Controle final des AUTO_INCREMENT
            self.status("Controles finaux...")
            no_ai = missing_auto_increment(cfg)
            if no_ai:
                self.log("   [ATTENTION] Cles primaires sans AUTO_INCREMENT : %s" % ", ".join(no_ai))
            else:
                self.log(">> Controle AUTO_INCREMENT : toutes les cles compteurs sont en AUTO_INCREMENT.")
            self.progress(steps_max)
        finally:
            # Les CSV contiennent des donnees personnelles : toujours supprimes.
            shutil.rmtree(tmp_dir, ignore_errors=True)

        # Bilan
        self.log("\n=== Bilan ===")
        self.log("   Duree : %d s" % int(time.time() - t0))
        self.log("   Avertissements MySQL a l'import : %d" % warnings_total)
        for t, n in warn_tables:
            self.log("     - %s : %d (details dans le journal)" % (t, n))
        msgs = []
        if problems:
            msgs.append("%d table(s) presentent un ecart de comptage." % problems)
        if missing:
            msgs.append("%d table(s) PostgreSQL n'existent pas dans le schema MySQL." % len(missing))
        if warnings_total:
            msgs.append("%d avertissement(s) MySQL pendant l'import (troncatures, dates invalides...)."
                        % warnings_total)
        if ignored_cols:
            msgs.append("%d colonne(s) PostgreSQL sans equivalent MySQL (non importees)." % len(ignored_cols))
        if obj_fail:
            msgs.append("%d vue(s)/fonction(s)/declencheur(s) non cree(s) : %s"
                        % (len(obj_fail), ", ".join(obj_fail)))
        if fk_problems:
            msgs.append("%d cle(s) etrangere(s) non posee(s) (donnees orphelines ou erreur)."
                        % len(fk_problems))
        if no_ai:
            msgs.append("%d cle(s) primaire(s) sans AUTO_INCREMENT." % len(no_ai))
        msgs.extend(alerts)
        if not msgs:
            self.log("\n[OK] Migration terminee : toutes les tables concordent, aucun avertissement.")
            return "ok", "Migration terminee avec succes !\nToutes les tables concordent."
        msg = "Migration terminee AVEC AVERTISSEMENTS :\n- " + "\n- ".join(msgs)
        msg += "\nVoir le journal : %s\nPrevenir Webtinix." % self.j.path
        self.log("\n[ATTENTION] " + msg)
        return "attention", msg


# ---------------------------------------------------------------------------
# Interface graphique (inchangee pour l'utilisateur)
# ---------------------------------------------------------------------------

def run_gui():
    import tkinter as tk
    from tkinter import ttk, messagebox

    class App(tk.Tk):
        def __init__(self):
            super().__init__()
            self.title(APP_TITLE)
            self.geometry("760x600")
            self.minsize(680, 520)
            self.cfg, self.cfg_path = load_config()
            self._build_ui()

        def _build_ui(self):
            pad = {"padx": 12, "pady": 6}
            tk.Label(self, text="Migration EDUVERSE", font=("Segoe UI", 18, "bold")).pack(anchor="w", **pad)

            info = tk.Frame(self)
            info.pack(fill="x", **pad)
            src = "%s  (%s:%s)" % (self.cfg["postgres"]["database"],
                                   self.cfg["postgres"]["host"], self.cfg["postgres"]["port"])
            dst = "%s  (%s:%s)" % (self.cfg["mysql"]["database"],
                                   self.cfg["mysql"]["host"], self.cfg["mysql"]["port"])
            tk.Label(info, text="Source PostgreSQL :", font=("Segoe UI", 10, "bold")).grid(row=0, column=0, sticky="w")
            tk.Label(info, text=src).grid(row=0, column=1, sticky="w", padx=8)
            tk.Label(info, text="Cible MySQL :", font=("Segoe UI", 10, "bold")).grid(row=1, column=0, sticky="w")
            tk.Label(info, text=dst).grid(row=1, column=1, sticky="w", padx=8)

            tk.Label(self, text="Schema : %s" % schema_path(self.cfg, self.cfg_path),
                     fg="#777").pack(anchor="w", padx=12)
            tk.Label(self, text="Reglages : %s" % self.cfg_path, fg="#777").pack(anchor="w", padx=12)

            self.btn = tk.Button(self, text="  Demarrer la migration  ", font=("Segoe UI", 13, "bold"),
                                 bg="#2e7d32", fg="white", activebackground="#1b5e20",
                                 relief="flat", padx=20, pady=10, command=self.start)
            self.btn.pack(pady=14)

            self.progress = ttk.Progressbar(self, mode="determinate")
            self.progress.pack(fill="x", padx=12, pady=4)
            self.status = tk.Label(self, text="Pret.", fg="#333", font=("Segoe UI", 10))
            self.status.pack(anchor="w", padx=12)

            box = tk.Frame(self)
            box.pack(fill="both", expand=True, padx=12, pady=8)
            self.log = tk.Text(box, height=16, wrap="word", state="disabled",
                               bg="#1e1e1e", fg="#d4d4d4", font=("Consolas", 9))
            sb = tk.Scrollbar(box, command=self.log.yview)
            self.log.configure(yscrollcommand=sb.set)
            self.log.pack(side="left", fill="both", expand=True)
            sb.pack(side="right", fill="y")

        def write(self, msg):
            def _do():
                self.log.configure(state="normal")
                self.log.insert("end", msg + "\n")
                self.log.see("end")
                self.log.configure(state="disabled")
            self.after(0, _do)

        def set_status(self, text, color="#333"):
            self.after(0, lambda: self.status.configure(text=text, fg=color))

        def set_progress(self, value, maximum=None):
            def _do():
                if maximum is not None:
                    self.progress.configure(maximum=maximum)
                self.progress.configure(value=value)
            self.after(0, _do)

        def start(self):
            db = self.cfg["mysql"]["database"]
            if not messagebox.askyesno(
                    APP_TITLE,
                    "La base MySQL  «%s»  va etre RECREEE.\n"
                    "Toutes les donnees qu'elle contient seront effacees,\n"
                    "puis remplacees par les donnees de PostgreSQL.\n\nContinuer ?" % db):
                return
            self.btn.configure(state="disabled")
            self.log.configure(state="normal")
            self.log.delete("1.0", "end")
            self.log.configure(state="disabled")
            threading.Thread(target=self._run_migration, daemon=True).start()

        def _run_migration(self):
            journal = Journal(display=self.write)
            try:
                level, msg = Migration(self.cfg, self.cfg_path, journal,
                                       status=self.set_status, progress=self.set_progress).run()
                if level == "ok":
                    self.set_status("Migration terminee avec succes.", "#2e7d32")
                    self.after(0, lambda m=msg: messagebox.showinfo(APP_TITLE, m))
                else:
                    # Message orange : avertissements a transmettre a Webtinix.
                    self.set_status("Termine avec avertissements : voir le journal.", "#e65100")
                    self.after(0, lambda m=msg: messagebox.showwarning(APP_TITLE, m))
            except Exception as e:
                journal.write("\n[ERREUR] " + str(e))
                self.set_status("Echec.", "#c62828")
                self.after(0, lambda e=e: messagebox.showerror(
                    APP_TITLE, "La migration a echoue :\n\n%s\n\nJournal : %s" % (e, journal.path)))
            finally:
                journal.close()
                self.after(0, lambda: self.btn.configure(state="normal"))

    App().mainloop()


# ---------------------------------------------------------------------------
# Mode sans interface
# ---------------------------------------------------------------------------

def run_cli(args):
    """Codes de sortie : 0 = succes, 1 = termine avec avertissements, 2 = echec, 3 = annule."""
    def out(msg):
        if sys.stdout is None:
            return
        try:
            print(msg, flush=True)
        except UnicodeEncodeError:
            print(msg.encode("ascii", "replace").decode("ascii"), flush=True)

    cfg, cfg_path = load_config(os.path.abspath(args.config) if args.config else None)
    db = cfg["mysql"]["database"]
    if not args.oui:
        if sys.stdin is None or not sys.stdin.isatty():
            out("La base MySQL '%s' serait RECREEE : ajouter --oui pour confirmer." % db)
            return 3
        rep = input("La base MySQL '%s' va etre RECREEE (donnees effacees). Continuer ? [o/N] " % db)
        if rep.strip().lower() not in ("o", "oui", "y", "yes"):
            out("Annule.")
            return 3
    journal = Journal(display=out)
    try:
        level, _msg = Migration(cfg, cfg_path, journal).run()
        return 0 if level == "ok" else 1
    except Exception as e:
        journal.write("\n[ERREUR] La migration a echoue :\n" + str(e))
        return 2
    finally:
        journal.close()


def main():
    parser = argparse.ArgumentParser(description=APP_TITLE)
    parser.add_argument("--sans-interface", "--cli", dest="cli", action="store_true",
                        help="lancer sans fenetre (journal sur la console et dans le fichier)")
    parser.add_argument("--oui", action="store_true",
                        help="ne pas demander de confirmation avant de recreer la base MySQL")
    parser.add_argument("--config", help="chemin d'un autre fichier config.ini")
    args, _unknown = parser.parse_known_args()
    if args.cli:
        sys.exit(run_cli(args))
    run_gui()


if __name__ == "__main__":
    main()
