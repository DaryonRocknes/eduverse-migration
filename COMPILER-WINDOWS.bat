@echo off
chcp 65001 >nul
title Fabrication de Migration-EDUVERSE.exe
color 0A

echo ================================================================
echo    FABRICATION DE  Migration-EDUVERSE.exe   (Webtinix)
echo ================================================================
echo.
echo  Ce programme va, tout seul :
echo    1. verifier Python
echo    2. installer l'outil de compilation (PyInstaller)
echo    3. fabriquer Migration-EDUVERSE.exe
echo    4. preparer le dossier a livrer au client
echo.
echo  Ne fermez pas cette fenetre avant le message  TERMINE.
echo.
pause
echo.

REM ----- 1. Verifier que Python est installe -----
set "PYTHON="
where python >nul 2>nul && set "PYTHON=python"
if not defined PYTHON ( where py >nul 2>nul && set "PYTHON=py" )

if not defined PYTHON (
    echo.
    echo [PROBLEME] Python n'est pas installe (ou pas ajoute au PATH^).
    echo.
    echo  A FAIRE :
    echo    1. Aller sur  https://www.python.org/downloads/
    echo    2. Telecharger Python 3 et l'installer
    echo    3. TRES IMPORTANT : cocher la case  "Add Python to PATH"
    echo    4. Relancer ce fichier  COMPILER-WINDOWS.bat
    echo.
    pause
    exit /b 1
)

echo Python detecte :
%PYTHON% --version
echo.

REM ----- 2. Installer PyInstaller -----
echo Installation de l'outil de compilation (1 a 2 minutes)...
%PYTHON% -m pip install --quiet --upgrade pip pyinstaller
if errorlevel 1 (
    echo.
    echo [PROBLEME] L'installation a echoue. Verifiez votre connexion Internet, puis relancez.
    echo.
    pause
    exit /b 1
)
echo Outil installe.
echo.

REM ----- 3. Compiler -----
echo Compilation en cours... (1 a 3 minutes, NE FERMEZ PAS la fenetre^)
echo.
%PYTHON% -m PyInstaller --onefile --windowed --name "Migration-EDUVERSE" --clean migration.py
if errorlevel 1 (
    echo.
    echo [PROBLEME] La compilation a echoue. Notez le message ci-dessus.
    echo.
    pause
    exit /b 1
)
echo.

REM ----- 4. Preparer le dossier a livrer -----
set "DEST=Migration-EDUVERSE-Windows"
if exist "%DEST%" rmdir /s /q "%DEST%"
mkdir "%DEST%"
copy /y "dist\Migration-EDUVERSE.exe" "%DEST%\" >nul
copy /y "config.ini" "%DEST%\" >nul
copy /y "schema_mysql.sql" "%DEST%\" >nul
if exist "LISEZ-MOI.txt" copy /y "LISEZ-MOI.txt" "%DEST%\" >nul

echo ================================================================
echo    TERMINE  !
echo ================================================================
echo.
echo  Votre application est prete dans le dossier :
echo      %CD%\%DEST%
echo.
echo  Ce dossier contient :
echo      Migration-EDUVERSE.exe     (le programme^)
echo      config.ini                 (les reglages^)
echo      schema_mysql.sql           (le schema^)
echo.
echo  -^> Donnez ce dossier au client. Il double-clique sur le .exe.
echo  -^> Pensez a regler config.ini (chemins Windows de psql et mysql^).
echo.
pause
