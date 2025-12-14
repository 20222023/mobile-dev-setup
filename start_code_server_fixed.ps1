# Fixed code-server startup script
# Uses an older version that works better on Windows

Write-Host "=== Starting Code-Server (Fixed Version) ===" -ForegroundColor Green

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

# Try using an older version that works better on Windows
# Version 4.23.0 is known to work better on Windows
Write-Host "Starting code-server (this may take a moment on first run)..." -ForegroundColor Cyan
Write-Host ""

# Use --ignore-scripts to skip postinstall that requires sh
$env:SKIP_POSTINSTALL = "true"
npx --yes --ignore-scripts code-server@4.23.0 --bind-addr 0.0.0.0:8080 --auth password

