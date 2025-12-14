# PowerShell script to set up SSH server on Windows
# Run as Administrator

Write-Host "=== Windows SSH Server Setup ===" -ForegroundColor Green

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "1. Installing OpenSSH Server..." -ForegroundColor Cyan
try {
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -ErrorAction Stop
    Write-Host "   OpenSSH Server installed" -ForegroundColor Green
} catch {
    $installed = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
    if ($installed.State -eq 'Installed') {
        Write-Host "   OpenSSH Server already installed" -ForegroundColor Green
    } else {
        Write-Host "   Failed to install OpenSSH Server" -ForegroundColor Red
        Write-Host "   Error: $_" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "2. Starting SSH Service..." -ForegroundColor Cyan
try {
    Start-Service sshd
    Set-Service -Name sshd -StartupType 'Automatic'
    Write-Host "   SSH Service started and set to auto-start" -ForegroundColor Green
} catch {
    Write-Host "   Failed to start SSH service" -ForegroundColor Red
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "3. Configuring Firewall..." -ForegroundColor Cyan
try {
    $firewallRule = Get-NetFirewallRule -Name sshd -ErrorAction SilentlyContinue
    if ($firewallRule) {
        Write-Host "   Firewall rule already exists" -ForegroundColor Green
    } else {
        New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
        Write-Host "   Firewall rule created" -ForegroundColor Green
    }
} catch {
    Write-Host "   Failed to configure firewall" -ForegroundColor Red
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "4. Getting Network Information..." -ForegroundColor Cyan
$ipAddresses = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*"} | Select-Object -ExpandProperty IPAddress
Write-Host "   Your IP Address(es):" -ForegroundColor Yellow
foreach ($ip in $ipAddresses) {
    Write-Host "   - $ip" -ForegroundColor White
}

Write-Host ""
Write-Host "5. Getting Username..." -ForegroundColor Cyan
$username = $env:USERNAME
Write-Host "   Username: $username" -ForegroundColor Yellow

Write-Host ""
Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host ""
Write-Host "To connect from your mobile device:" -ForegroundColor Cyan
Write-Host "  Host: $($ipAddresses[0])" -ForegroundColor White
Write-Host "  Port: 22" -ForegroundColor White
Write-Host "  Username: $username" -ForegroundColor White
Write-Host "  Password: Your Windows password" -ForegroundColor White
Write-Host ""
Write-Host "Recommended mobile apps:" -ForegroundColor Cyan
Write-Host "  - Termius (iOS/Android)" -ForegroundColor White
Write-Host "  - JuiceSSH (Android)" -ForegroundColor White
Write-Host "  - Blink Shell (iOS)" -ForegroundColor White
