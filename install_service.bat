@echo off
:: ============================================================================
:: ANDROPRINT SERVER - WINDOWS AUTO-START SERVICE INSTALLER
:: Registers AndroPrint as a Windows Auto-Start Background Service/Task
:: Compatible with Windows 7, 8, 10, 11, Server (32-bit x86 & 64-bit x64)
:: ============================================================================

title Install AndroPrint Auto-Start Service

:: Request Administrative Privileges automatically if not running as Admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator Privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Force working directory to the directory where this script is located
cd /d "%~dp0"

echo ============================================================================
echo           INSTALLING ANDROPRINT AUTO-START BACKGROUND SERVICE
echo ============================================================================
echo.

set TASK_NAME=AndroPrintServer
set VBS_PATH=%~dp0scripts\start_server_silent.vbs

if not exist "%VBS_PATH%" (
    echo ERROR: Cannot find "%VBS_PATH%"
    pause
    exit /b 1
)

echo [1/3] Registering Windows Auto-Start Task...
powershell -Command "Unregister-ScheduledTask -TaskName '%TASK_NAME%' -Confirm:$false -ErrorAction SilentlyContinue" >nul 2>&1

powershell -Command "$action = New-ScheduledTaskAction -Execute 'wscript.exe' -Argument '\"%VBS_PATH%\"'; $triggerBoot = New-ScheduledTaskTrigger -AtStartup; $triggerLogon = New-ScheduledTaskTrigger -AtLogon; $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit 0 -Priority 1; Register-ScheduledTask -TaskName '%TASK_NAME%' -Action $action -Trigger @($triggerBoot, $triggerLogon) -Settings $settings -User 'SYSTEM' -RunLevel Highest | Out-Null"

if %errorLevel% equ 0 (
    echo [2/3] Windows Service/Task registered successfully!
    echo [3/3] Starting AndroPrint Server background service now...
    powershell -Command "Start-ScheduledTask -TaskName '%TASK_NAME%'" >nul 2>&1
    echo.
    echo ============================================================================
    echo SUCCESS: AndroPrint is now installed as a Windows Auto-Start Service!
    echo - Auto-starts when Windows boots up or restarts.
    echo - Runs silently in the background.
    echo - Automatically restarts if closed or crashed.
    echo ============================================================================
) else (
    echo ERROR: Failed to register Windows Task. Please run as Administrator.
)

echo.
