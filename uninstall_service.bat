@echo off
:: ============================================================================
:: ANDROPRINT SERVER - WINDOWS SERVICE UNINSTALLER
:: Unregisters and stops the AndroPrint Background Service/Task
:: ============================================================================

title Uninstall AndroPrint Auto-Start Service

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
echo          UNINSTALLING ANDROPRINT AUTO-START BACKGROUND SERVICE
echo ============================================================================
echo.

set TASK_NAME=AndroPrintServer

echo [1/2] Stopping service and background processes...
powershell -Command "Stop-ScheduledTask -TaskName '%TASK_NAME%' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Get-Process node -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like '*server.js*' -or $_.CommandLine -like '*watchdog.js*'} | Stop-Process -Force -ErrorAction SilentlyContinue" >nul 2>&1

echo [2/2] Removing Windows Auto-Start Task...
powershell -Command "Unregister-ScheduledTask -TaskName '%TASK_NAME%' -Confirm:$false -ErrorAction SilentlyContinue" >nul 2>&1

echo.
echo ============================================================================
echo SUCCESS: AndroPrint Windows Auto-Start Service has been uninstalled.
echo ============================================================================
echo.
pause
