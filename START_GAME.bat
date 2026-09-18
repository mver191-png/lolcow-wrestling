@echo off
setlocal
cd /d "%~dp0"
if defined GODOT_BIN (
  "%GODOT_BIN%" --path "%CD%" %*
  exit /b %errorlevel%
)
for %%G in (Godot_v*_win64.exe Godot_v*_win64_console.exe godot.exe) do (
  if exist "%%G" (
    "%%G" --path "%CD%" %*
    exit /b
  )
)
where godot >nul 2>&1
if not errorlevel 1 (
  godot --path "%CD%" %*
  exit /b
)
echo Godot was not found. Place Godot 4.7.2 beside this launcher,
echo add godot to PATH, or set GODOT_BIN to the executable path.
echo This launcher opens the source project; it is not a Windows export.
pause
exit /b 1
