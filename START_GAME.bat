@echo off
title LOLCOW WRESTLING: OFFLINE MAYHEM
cd /d "%~dp0"
echo Starting LOLCOW WRESTLING: OFFLINE MAYHEM...

set "GODOT_EXE=C:\Users\mauri\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_win64.exe"
if exist "%GODOT_EXE%" (
    start "" "%GODOT_EXE%" --path "%CD%"
    exit /b 0
)

start "" "godot.exe" --path "%CD%"
exit /b 0
