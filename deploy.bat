@echo off
chcp 65001 >nul
title Deploy to GitHub Pages

cd /d "%~dp0"

echo.
echo  ╔══════════════════════════════════╗
echo  ║   Deploy to GitHub Pages         ║
echo  ╚══════════════════════════════════╝
echo.

:: Check for changes
git status --short > nul 2>&1
for /f %%i in ('git status --short') do set CHANGES=1

if not defined CHANGES (
    echo  [!] Nothing to commit. Already up to date.
    echo.
    pause
    exit /b 0
)

:: Show what changed
echo  Changes detected:
git status --short
echo.

:: Ask for commit message (default = timestamp)
set /p MSG=" Commit message (Enter = auto timestamp): "
if "%MSG%"=="" (
    for /f "tokens=1-5 delims=:. " %%a in ("%date% %time%") do (
        set MSG=Update %%a-%%b-%%c %%d:%%e
    )
)

echo.
echo  Committing: %MSG%
echo.

git add -A
git commit -m "%MSG%"

echo.
echo  Pushing to GitHub...
git push origin main

echo.
if %ERRORLEVEL%==0 (
    echo  [OK] Done! Site will be live at:
    echo       https://samothracesmile.github.io
) else (
    echo  [ERR] Push failed. Check your connection or credentials.
)

echo.
pause
