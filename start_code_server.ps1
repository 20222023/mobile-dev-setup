# Quick script to start code-server using npx
# This will start code-server and show you the access URL and password

Write-Host "=== Starting Code-Server ===" -ForegroundColor Green

# Get IP address
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*"} | Select-Object -First 1).IPAddress

Write-Host ""
Write-Host "Code-server will start on:" -ForegroundColor Cyan
Write-Host "  http://$ipAddress:8080" -ForegroundColor White
Write-Host ""
Write-Host "A password will be generated and shown below." -ForegroundColor Yellow
Write-Host "Save it to access code-server from your mobile device!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
Write-Host ""
Write-Host ("="*50) -ForegroundColor Gray
Write-Host ""

# Check firewall (informational)
$firewallRule = Get-NetFirewallRule -Name "code-server" -ErrorAction SilentlyContinue
if (-not $firewallRule) {
    Write-Host "Note: You may need to allow port 8080 in Windows Firewall" -ForegroundColor Yellow
    Write-Host "Run as Administrator and execute:" -ForegroundColor Yellow
    Write-Host "  New-NetFirewallRule -Name 'code-server' -DisplayName 'Code-Server (8080)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 8080" -ForegroundColor White
    Write-Host ""
}

# Start code-server using npx
npx --yes code-server@latest --bind-addr 0.0.0.0:8080 --auth password
