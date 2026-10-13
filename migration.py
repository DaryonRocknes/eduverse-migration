# -*- coding: utf-8 -*-
r"""
EDUVERSE - Outil de migration PostgreSQL -> MySQL
Webtinix

Interface graphique simple : un bouton "Demarrer la migration".

Etapes automatiques :
  1. (Re)creation de la base MySQL  (DROP + CREATE DATABASE en utf8mb4)
  2. Chargement du schema fixe EDUVERSE  (fichier schema_mysql.sql : tables, cles, AUTO_INCREMENT)
  3. Export de chaque table PostgreSQL en CSV  (\copy ... CSV HEADER)
  4. Import dans MySQL via LOAD DATA LOCAL INFILE, avec conversions automatiques :
        - booleens PostgreSQL  t/f         -> 1/0
        - champs vides (NULL PG)           -> NULL
        - dates 0000-00-00 / vides         -> NULL
     Ces regles sont deduites des types lus directement dans PostgreSQL.
  5. Verification des comptages source / cible.

Fonctionne sous Windows et Linux.
Reglages : fichier  config.ini  (a cote de ce programme).
Schema   : fichier  schema_mysql.sql  (a cote de ce programme).
"""

import os
import sys
import tempfile
import threading
import subprocess
import configparser
import tkinter as tk
from tkinter import ttk, messagebox

APP_TITLE = "EDUVERSE - Migration PostgreSQL vers MySQL"


# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

def base_dir():
    """Dossier du programme (compatible avec PyInstaller)."""
    if getattr(sys, "frozen", False):
        return os.path.dirname(sys.executable)
    return os.path.dirname(os.path.abspath(__file__))


def default_config():
    cfg = configparser.ConfigParser()
    is_win = sys.platform.startswith("win")
    cfg["postgres"] = {
        "psql": (r"C:\Program Files\PostgreSQL\16\bin\psql.exe" if is_win else "psql"),
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
    return cfg


def load_config():
    path = os.path.join(base_dir(), "config.ini")
    cfg = default_config()
    if os.path.exists(path):
        cfg.read(path, encoding="utf-8")
    else:
        with open(path, "w", encoding="utf-8") as f:
            cfg.write(f)
    return cfg, path


def schema_path(cfg):
    name = cfg["mysql"].get("schema_file", "schema_mysql.sql")
    if not os.path.isabs(name):
        name = os.path.join(base_dir(), name)
    return name


# ---------------------------------------------------------------------------
# Lancement de commandes psql / mysql
# ---------------------------------------------------------------------------

def run(cmd, env=None, stdin_path=None):
    """Lance une commande, renvoie (code, sortie_texte). stdin_path = fichier a injecter en entree."""
    full_env = os.environ.copy()
    if env:
        full_env.update(env)
    stdin = open(stdin_path, "rb") if stdin_path else None
    try:
        proc = subprocess.run(
            cmd, env=full_env, stdin=stdin,
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            text=True, encoding="utf-8", errors="replace",
        )
    finally:
        if stdin:
            stdin.close()
    return proc.returncode, (proc.stdout or "")


def pg_env(cfg):
    return {"PGPASSWORD": cfg["postgres"]["password"]}


def mysql_env(cfg):
    return {"MYSQL_PWD": cfg["mysql"]["password"]}


def pg_base(cfg):
    p = cfg["postgres"]
    return [p["psql"], "-h", p["host"], "-p", p["port"], "-U", p["user"], "-d", p["database"]]


def mysql_base(cfg, with_db=True):
    m = cfg["mysql"]
    cmd = [m["mysql"], "--local-infile=1", "-h", m["host"], "-P", m["port"], "-u", m["user"]]
    if with_db:
        cmd.append(m["database"])
    return cmd


# ---------------------------------------------------------------------------
# PostgreSQL : liste des tables, schema des colonnes, comptages
# ---------------------------------------------------------------------------

def list_tables(cfg):
    cmd = pg_base(cfg) + ["-t", "-A", "-c",
                          "SELECT tablename FROM pg_tables WHERE schemaname='public' ORDER BY tablename;"]
    code, out = run(cmd, pg_env(cfg))
    if code != 0:
        raise RuntimeError("Connexion PostgreSQL impossible :\n" + out)
    return [t.strip() for t in out.splitlines() if t.strip()]


def get_table_schema(cfg, table):
    """Renvoie [(nom_colonne, type_pg_udt, nullable_bool), ...] dans l'ordre des colonnes."""
    q = ("SELECT column_name, udt_name, is_nullable "
         "FROM information_schema.columns "
         "WHERE table_schema='public' AND table_name='%s' "
         "ORDER BY ordinal_position;" % table.replace("'", "''"))
    code, out = run(pg_base(cfg) + ["-t", "-A", "-F", "|", "-c", q], pg_env(cfg))
    if code != 0:
        raise RuntimeError("Lecture du schema de '%s' echouee :\n%s" % (table, out))
    cols = []
    for line in out.splitlines():
        if not line.strip():
            continue
        parts = line.split("|")
        if len(parts) >= 3:
            cols.append((parts[0], parts[1].lower(), parts[2].strip().upper() == "YES"))
    return cols


def pg_count(cfg, table):
    cmd = pg_base(cfg) + ["-t", "-A", "-c", 'SELECT COUNT(*) FROM "%s";' % table]
    code, out = run(cmd, pg_env(cfg))
    return out.strip() if code == 0 else "?"


def mysql_count(cfg, table):
    cmd = mysql_base(cfg) + ["-N", "-e", "SELECT COUNT(*) FROM `%s`;" % table]
    code, out = run(cmd, mysql_env(cfg))
    return out.strip() if code == 0 else "?"


# ---------------------------------------------------------------------------
# Categorisation des types PostgreSQL -> regle de conversion a l'import
# ---------------------------------------------------------------------------

BOOL_TYPES = {"bool"}
NUM_TYPES = {"int2", "int4", "int8", "numeric", "float4", "float8", "money"}
DATE_TYPES = {"date"}
DATETIME_TYPES = {"timestamp", "timestamptz"}
TIME_TYPES = {"time", "timetz"}


def column_category(udt):
    if udt in BOOL_TYPES:
        return "bool"
    if udt in NUM_TYPES:
        return "num"
    if udt in DATE_TYPES:
        return "date"
    if udt in DATETIME_TYPES:
        return "datetime"
    if udt in TIME_TYPES:
        return "time"
    return "str"


# ---------------------------------------------------------------------------
# Export / Import d'une table
# ---------------------------------------------------------------------------

def export_table(cfg, table, csv_dir):
    csv_path = os.path.join(csv_dir, table + ".csv")
    sql = "\\copy \"%s\" TO '%s' CSV HEADER" % (table, csv_path.replace("\\", "/"))
    code, out = run(pg_base(cfg) + ["-c", sql], pg_env(cfg))
    if code != 0:
        raise RuntimeError("Export de '%s' echoue :\n%s" % (table, out))
    return csv_path


def build_load_sql(cfg, table, schema, csv_path, mysql_cols):
    """Construit la requete LOAD DATA avec les conversions deduites des types PG.

    mysql_cols : ensemble des noms de colonnes (en minuscules) presents dans la table MySQL.
    Une colonne PostgreSQL absente de MySQL est lue puis ignoree (pas d'erreur)."""
    csv_unix = csv_path.replace("\\", "/")
    col_clause = []
    set_parts = []
    for i, (name, udt, nullable) in enumerate(schema):
        var = "@c%d" % i
        # Colonne presente dans PostgreSQL mais absente de MySQL : on l'ecarte.
        if name.lower() not in mysql_cols:
            col_clause.append(var)
            continue
        cat = column_category(udt)
        col_q = "`%s`" % name
        if cat == "bool":
            col_clause.append(var)
            set_parts.append(
                "%s = IF(%s IN ('t','true','TRUE','1'),1,"
                "IF(%s IN ('f','false','FALSE','0'),0,NULL))" % (col_q, var, var))
        elif cat in ("num", "str"):
            if nullable:
                col_clause.append(var)
                set_parts.append("%s = NULLIF(%s,'')" % (col_q, var))
            else:
                col_clause.append(col_q)
        elif cat == "date":
            if nullable:
                col_clause.append(var)
                set_parts.append("%s = NULLIF(NULLIF(%s,''),'0000-00-00')" % (col_q, var))
            else:
                col_clause.append(col_q)
        elif cat in ("datetime", "time"):
            if nullable:
                col_clause.append(var)
                set_parts.append(
                    "%s = NULLIF(NULLIF(NULLIF(%s,''),'0000-00-00'),'0000-00-00 00:00:00')"
                    % (col_q, var))
            else:
                col_clause.append(col_q)

    sql = (
        "SET SESSION sql_mode = '';\n"
        "SET FOREIGN_KEY_CHECKS = 0;\n"
        "LOAD DATA LOCAL INFILE '%s'\n"
        "INTO TABLE `%s`\n"
        "CHARACTER SET utf8mb4\n"
        "FIELDS TERMINATED BY ',' ENCLOSED BY '\"'\n"
        "LINES TERMINATED BY '\\n'\n"
        "IGNORE 1 ROWS\n"
        "(%s)" % (csv_unix, table, ", ".join(col_clause))
    )
    if set_parts:
        sql += "\nSET " + ",\n    ".join(set_parts)
    sql += ";"
    return sql


def get_mysql_columns(cfg, table):
    """Renvoie l'ensemble des noms de colonnes (en minuscules) de la table MySQL."""
    code, out = run(mysql_base(cfg) + ["-N", "-e", "SHOW COLUMNS FROM `%s`;" % table], mysql_env(cfg))
    if code != 0:
        raise RuntimeError("Lecture des colonnes MySQL de '%s' echouee :\n%s" % (table, out))
    cols = set()
    for line in out.splitlines():
        if line.strip():
            cols.add(line.split("\t")[0].strip().lower())
    return cols


def import_table(cfg, table, schema, csv_path):
    mysql_cols = get_mysql_columns(cfg, table)
    sql = build_load_sql(cfg, table, schema, csv_path, mysql_cols)
    code, out = run(mysql_base(cfg) + ["-e", sql], mysql_env(cfg))
    if code != 0:
        raise RuntimeError("Import de '%s' echoue :\n%s" % (table, out))
    # Signale les colonnes PG ecartees (presentes dans PostgreSQL mais pas dans MySQL)
    extra = [n for (n, _u, _nu) in schema if n.lower() not in mysql_cols]
    return extra


# ---------------------------------------------------------------------------
# Creation de la base + chargement du schema
# ---------------------------------------------------------------------------

def recreate_database(cfg):
    db = cfg["mysql"]["database"]
    sql = ("DROP DATABASE IF EXISTS `%s`; "
           "CREATE DATABASE `%s` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" % (db, db))
    code, out = run(mysql_base(cfg, with_db=False) + ["-e", sql], mysql_env(cfg))
    if code != 0:
        raise RuntimeError("Creation de la base MySQL impossible :\n" + out)


def load_schema(cfg):
    path = schema_path(cfg)
    if not os.path.exists(path):
        raise RuntimeError("Fichier de schema introuvable : %s" % path)
    code, out = run(mysql_base(cfg) + ["--default-character-set=utf8mb4"],
                    mysql_env(cfg), stdin_path=path)
    if code != 0:
        raise RuntimeError("Chargement du schema echoue :\n" + out)


def mysql_tables(cfg):
    code, out = run(mysql_base(cfg) + ["-N", "-e", "SHOW TABLES;"], mysql_env(cfg))
    if code != 0:
        return set()
    return {t.strip() for t in out.splitlines() if t.strip()}


# ---------------------------------------------------------------------------
# Interface graphique
# ---------------------------------------------------------------------------

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

        tk.Label(self, text="Schema : %s" % schema_path(self.cfg), fg="#777").pack(anchor="w", padx=12)
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

    def set_status(self, text):
        self.after(0, lambda: self.status.configure(text=text))

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
        try:
            # 0) Connexion + liste des tables PostgreSQL
            self.set_status("Connexion a PostgreSQL...")
            self.write(">> Lecture des tables PostgreSQL...")
            tables = list_tables(self.cfg)
            if not tables:
                raise RuntimeError("Aucune table trouvee dans le schema 'public'.")
            self.write("   %d tables detectees." % len(tables))

            total = len(tables)
            self.set_progress(0, total * 2 + 2)
            step = 0

            # 1) Recreation de la base
            self.set_status("Creation de la base MySQL...")
            self.write(">> (Re)creation de la base MySQL...")
            recreate_database(self.cfg)
            step += 1
            self.set_progress(step)

            # 2) Chargement du schema fixe
            self.set_status("Chargement du schema EDUVERSE...")
            self.write(">> Chargement du schema (tables, cles, AUTO_INCREMENT)...")
            load_schema(self.cfg)
            mtabs = mysql_tables(self.cfg)
            self.write("   %d tables creees dans MySQL." % len(mtabs))
            step += 1
            self.set_progress(step)

            # Tables PG sans equivalent MySQL (on les signale, on ne les importe pas)
            missing = [t for t in tables if t not in mtabs]
            if missing:
                self.write("   [INFO] Tables PG absentes du schema MySQL (ignorees) : %s"
                           % ", ".join(missing))
            todo = [t for t in tables if t in mtabs]

            # 3) Export CSV + lecture des schemas
            schemas = {}
            csv_dir = tempfile.mkdtemp(prefix="eduverse_csv_")
            for t in todo:
                self.set_status("Export de %s..." % t)
                self.write(">> Export   : %s" % t)
                schemas[t] = get_table_schema(self.cfg, t)
                export_table(self.cfg, t, csv_dir)
                step += 1
                self.set_progress(step)

            # 4) Import
            for t in todo:
                self.set_status("Import de %s..." % t)
                self.write(">> Import   : %s" % t)
                extra = import_table(self.cfg, t, schemas[t], os.path.join(csv_dir, t + ".csv"))
                if extra:
                    self.write("     (colonnes PG ignorees, absentes de MySQL : %s)" % ", ".join(extra))
                step += 1
                self.set_progress(step)

            # 5) Verification des comptages
            self.set_status("Verification des comptages...")
            self.write("\n=== Verification (lignes PostgreSQL -> MySQL) ===")
            problems = 0
            for t in todo:
                s = pg_count(self.cfg, t)
                d = mysql_count(self.cfg, t)
                ok = (s == d)
                if not ok:
                    problems += 1
                self.write("   %-34s  %7s -> %7s   %s"
                           % (t, s, d, "OK" if ok else "!! DIFFERENCE"))

            self.set_progress(total * 2 + 2)
            if problems == 0 and not missing:
                self.set_status("Migration terminee avec succes.")
                self.write("\n[OK] Migration terminee : toutes les tables concordent.")
                self.after(0, lambda: messagebox.showinfo(
                    APP_TITLE, "Migration terminee avec succes !\nToutes les tables concordent."))
            else:
                msg = "Migration terminee."
                if problems:
                    msg += "\n%d table(s) presentent un ecart de comptage." % problems
                if missing:
                    msg += "\n%d table(s) PostgreSQL n'existent pas dans le schema MySQL." % len(missing)
                msg += "\nVoir le journal."
                self.set_status("Termine avec avertissements.")
                self.write("\n[ATTENTION] " + msg.replace("\n", " "))
                self.after(0, lambda m=msg: messagebox.showwarning(APP_TITLE, m))
        except Exception as e:
            self.set_status("Echec.")
            self.write("\n[ERREUR] " + str(e))
            self.after(0, lambda: messagebox.showerror(APP_TITLE, "La migration a echoue :\n\n" + str(e)))
        finally:
            self.after(0, lambda: self.btn.configure(state="normal"))


if __name__ == "__main__":
    App().mainloop()
