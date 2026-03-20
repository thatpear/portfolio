@echo off
setlocal enabledelayedexpansion

REM Change to the script directory
cd /d "%~dp0"

REM Run PowerShell script with proper execution policy
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0generate-gallery.ps1"

if errorlevel 1 (
    echo.
    echo Error running the gallery generator
    pause
) else (
    echo.
    echo Press any key to close...
    pause
)
