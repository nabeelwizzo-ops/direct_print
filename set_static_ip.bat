@echo off
:: ============================================================================
:: ANDROPRINT SERVER - AUTOMATED STATIC IP SETUP
:: Double-click to automatically set static IP on client system
:: ============================================================================

title AndroPrint Static IP Setup

:: Request Administrative Privileges automatically if not running as Admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator Privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Force working directory to project folder
cd /d "%~dp0"

echo ============================================================================
echo                   ANDROPRINT AUTOMATED STATIC IP SETUP
echo ============================================================================
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0scripts\set_static_ip.ps1"

echo.
echo ============================================================================
echo Configuration completed! Press any key to close this window.
echo ============================================================================
pause >nul
