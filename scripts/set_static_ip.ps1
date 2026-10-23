# ==============================================================================
# AndroPrint Server - Set Static IP Script
# Run this script in PowerShell as Administrator to assign a static local IP.
# ==============================================================================

Param(
    [string]$InterfaceName = "",
    [string]$DesiredIP = "",
    [string]$Gateway = ""
)

$ErrorActionPreference = 'Stop'

# Auto-detect active network interface if not explicitly provided
if (-not $InterfaceName) {
    $activeAdapter = Get-NetIPConfiguration | Where-Object { $_.IPv4Address -and $_.IPv4DefaultGateway } | Select-Object -First 1
    if (-not $activeAdapter) {
        Write-Error "ERROR: No active network adapter with an active IPv4 address found."
        exit 1
    }
    $InterfaceAlias = $activeAdapter.InterfaceAlias
    $InterfaceIndex = $activeAdapter.InterfaceIndex
    $currentIP = $activeAdapter.IPv4Address.IPAddress
    $currentGW = $activeAdapter.IPv4DefaultGateway.NextHop
} else {
    $adapter = Get-NetAdapter -Name $InterfaceName -ErrorAction Stop
    $InterfaceAlias = $adapter.Name
    $InterfaceIndex = $adapter.ifIndex
    $config = Get-NetIPConfiguration -InterfaceIndex $InterfaceIndex
    $currentIP = $config.IPv4Address.IPAddress
    $currentGW = $config.IPv4DefaultGateway.NextHop
}

if (-not $DesiredIP) { $DesiredIP = $currentIP }
if (-not $Gateway) { $Gateway = $currentGW }

Write-Host "`nSetting Static IP configuration for: '$InterfaceAlias'..." -ForegroundColor Cyan
Write-Host "Target Static IP : $DesiredIP" -ForegroundColor Yellow
Write-Host "Gateway          : $Gateway" -ForegroundColor Yellow

# Disable DHCP and remove dynamic/existing IPs
Set-NetIPInterface -InterfaceIndex $InterfaceIndex -Dhcp Disabled -ErrorAction SilentlyContinue

Get-NetIPAddress -InterfaceIndex $InterfaceIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue | 
    Where-Object { $_.IPAddress -ne $DesiredIP -and $_.PrefixOrigin -ne 'WellKnown' } | 
    Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue

# Assign static IP if not already assigned
if (-not (Get-NetIPAddress -InterfaceIndex $InterfaceIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object IPAddress -eq $DesiredIP)) {
    New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress $DesiredIP -PrefixLength 24 -DefaultGateway $Gateway | Out-Null
}

# Set reliable DNS servers (Cloudflare / Google)
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ('1.1.1.1', '8.8.8.8')

Write-Host "`n========== STATIC NETWORK CONFIGURATION COMPLETED ==========" -ForegroundColor Green
Get-NetIPConfiguration -InterfaceIndex $InterfaceIndex | Format-List InterfaceAlias, IPv4Address, IPv4DefaultGateway, DNSServer
Write-Host "STATUS: Static IP successfully configured." -ForegroundColor Green
Write-Host "NOTE: System restarts/reboots will maintain this static IP." -ForegroundColor Yellow
