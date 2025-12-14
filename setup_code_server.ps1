# PowerShell script to set up code-server (web-based VS Code)
# Run as Administrator for firewall configuration

Write-Host "=== Code-Server Setup ===" -ForegroundColor Green

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Write-Host ""
Write-Host "1. Code-Server Setup..." -ForegroundColor Cyan
Write-Host "   Code-server will be run using npx (no installation needed)" -ForegroundColor Gray
Write-Host "   This means it will download and run on-demand" -ForegroundColor Gray

Write-Host "`n2. Configuring Firewall (port 8080)..." -ForegroundColor Cyan
if ($isAdmin) {
    try {
        $firewallRule = Get-NetFirewallRule -Name "code-server" -ErrorAction SilentlyContinue
        if ($firewallRule) {
            Write-Host "   ✓ Firewall rule already exists" -ForegroundColor Green
        } else {
            New-NetFirewallRule -Name "code-server" -DisplayName "Code-Server (8080)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 8080
            Write-Host "   ✓ Firewall rule created" -ForegroundColor Green
        }
    } catch {
        Write-Host "   ⚠ Could not configure firewall automatically" -ForegroundColor Yellow
        Write-Host "   You may need to allow port 8080 manually in Windows Firewall" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⚠ Not running as admin - skipping firewall configuration" -ForegroundColor Yellow
    Write-Host "   You may need to allow port 8080 manually in Windows Firewall" -ForegroundColor Yellow
}

Write-Host "`n3. Getting Network Information..." -ForegroundColor Cyan
$ipAddresses = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*"} | Select-Object -ExpandProperty IPAddress
Write-Host "   Your IP Address(es):" -ForegroundColor Yellow
foreach ($ip in $ipAddresses) {
    Write-Host "   - $ip" -ForegroundColor White
}

Write-Host "`n=== Setup Complete! ===" -ForegroundColor Green
Write-Host "`nTo start code-server, run:" -ForegroundColor Cyan
Write-Host "  code-server --bind-addr 0.0.0.0:8080 --auth password" -ForegroundColor White
Write-Host "`nThen access from your mobile browser:" -ForegroundColor Cyan
Write-Host "  http://$($ipAddresses[0]):8080" -ForegroundColor White
Write-Host "`nThe password will be shown in the terminal when you start code-server." -ForegroundColor Yellow
Write-Host "`nTo make it accessible from outside your network:" -ForegroundColor Cyan
Write-Host "  - Use a VPN (recommended)" -ForegroundColor White
Write-Host "  - Or use ngrok: ngrok http 8080" -ForegroundColor White


