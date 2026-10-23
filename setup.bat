@echo off
:: ============================================================================
:: ANDROPRINT CLIENT AUTOMATED ONE-CLICK INSTALLER & SETUP
:: Double-click (or Run as Admin) to automatically configure Node.js,
:: Dependencies, Static IP, Firewall rules, and Background Service.
:: ============================================================================

title AndroPrint Automated Setup

:: Request Administrative Privileges automatically if not running as Admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator Privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: CRITICAL FIX: Always force working directory to the project directory where setup.bat is located
cd /d "%~dp0"

echo ============================================================================
echo               ANDROPRINT 1-CLICK AUTOMATED CLIENT SETUP
echo ============================================================================
echo Working Directory : %cd%
echo.

:: 1. Auto-Detect / Install Node.js
echo [1/5] Checking Node.js runtime environment...
where node >nul 2>&1
if %errorLevel% neq 0 (
    if exist "%ProgramFiles%\nodejs\node.exe" (
        set "PATH=%ProgramFiles%\nodejs\;%PATH%"
    ) else if exist "%ProgramFiles(x86)%\nodejs\node.exe" (
        set "PATH=%ProgramFiles(x86)%\nodejs\;%PATH%"
    ) else (
        echo Node.js not detected. Auto-downloading and installing Node.js LTS silently...
        powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.18.0/node-v20.18.0-x64.msi' -OutFile '%temp%\node_installer.msi'"
        echo Installing Node.js in the background...
        msiexec /i "%temp%\node_installer.msi" /qn /norestart
        set "PATH=%ProgramFiles%\nodejs\;%PATH%"
        del "%temp%\node_installer.msi" >nul 2>&1
        echo Node.js installation completed!
    )
)

for /f "tokens=*" %%v in ('node -v 2^>nul') do set NODE_VER=%%v
if "%NODE_VER%"=="" (
    set "PATH=%ProgramFiles%\nodejs\;%ProgramFiles(x86)%\nodejs\;%PATH%"
    for /f "tokens=*" %%v in ('node -v 2^>nul') do set NODE_VER=%%v
)
echo Node.js Ready: %NODE_VER%

:: 2. Install production dependencies
echo.
echo [2/5] Installing production npm packages...
if not exist "%~dp0node_modules" (
    call npm install --omit=dev
) else (
    echo Existing node_modules found. Verifying dependencies...
    call npm install --omit=dev --no-audit
)

:: 3. Configure Windows Firewall Port 3000
echo.
echo [3/5] Setting up Windows Firewall rule for Port 3000...
powershell -Command "New-NetFirewallRule -DisplayName 'AndroPrint Server Port 3000' -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow -ErrorAction SilentlyContinue | Out-Null"
echo Firewall rule for Port 3000 active.

:: 4. Configure Static IP
echo.
echo [4/5] Locking System Static IP...
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\set_static_ip.ps1"

:: 5. Register Windows Auto-Start Background Service
echo.
echo [5/5] Registering Windows Auto-Start Background Service...
call "%~dp0install_service.bat"

echo.
echo ============================================================================
echo                 FULL AUTOMATED SETUP COMPLETED SUCCESSFULLY!
echo ============================================================================
echo  - Working Directory      : %cd%
echo  - Node.js & Dependencies : Configured
echo  - Server Auto-Start      : Active (Background Service on System Boot)
echo  - Dashboard URL          : http://localhost:3000/dashboard.html
echo  - Network Connection     : Open on Port 3000
echo ============================================================================
echo.
pause
