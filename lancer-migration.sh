#!/usr/bin/env bash
# Lanceur double-clic pour Linux (si on n'utilise pas le .exe / binaire PyInstaller).
# Rendre executable une fois :  chmod +x lancer-migration.sh
cd "$(dirname "$0")" || exit 1
python3 migration.py
