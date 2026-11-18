@echo off
setlocal EnableExtensions

echo Chiusura forzata di Outlook e di tutti i processi figli...
taskkill /F /T /IM OUTLOOK.EXE >nul 2>&1

rem Attendi che i processi siano terminati
timeout /t 3 /nobreak >nul

rem Cerca Outlook nel registro di Windows
set "OUTLOOK_PATH="
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE" /ve 2^>nul ^| findstr /i "REG_SZ REG_EXPAND_SZ"') do set "OUTLOOK_PATH=%%B"
if not defined OUTLOOK_PATH (
    for /f "tokens=2,*" %%A in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE" /ve 2^>nul ^| findstr /i "REG_SZ REG_EXPAND_SZ"') do set "OUTLOOK_PATH=%%B"
)

rem Percorsi comuni di Microsoft Office se la chiave non e' presente
if not defined OUTLOOK_PATH if exist "%ProgramFiles%\Microsoft Office\root\Office16\OUTLOOK.EXE" set "OUTLOOK_PATH=%ProgramFiles%\Microsoft Office\root\Office16\OUTLOOK.EXE"
if not defined OUTLOOK_PATH if exist "%ProgramFiles(x86)%\Microsoft Office\root\Office16\OUTLOOK.EXE" set "OUTLOOK_PATH=%ProgramFiles(x86)%\Microsoft Office\root\Office16\OUTLOOK.EXE"

rem Riavvia Outlook
echo Riavvio di Outlook...
if defined OUTLOOK_PATH (
    if exist "%OUTLOOK_PATH%" (
        start "" "%OUTLOOK_PATH%"
    ) else (
        start "" outlook.exe
    )
) else (
    start "" outlook.exe
)

endlocal
