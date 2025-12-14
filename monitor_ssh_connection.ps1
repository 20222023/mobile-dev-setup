# Monitor SSH Connection - Runs until you successfully authenticate
# This script will keep running and show connection status

$configFile = "ssh_config.json"
$username = $env:USERNAME

if (-not (Test-Path $configFile)) {
    Write-Host "Configuration file not found!" -ForegroundColor Red
    Write-Host "Run complete_ssh_setup.ps1 first (as Administrator)" -ForegroundColor Yellow
    exit 1
}

$config = Get-Content $configFile | ConvertFrom-Json

Write-Host ""
Write-Host "=== SSH Connection Monitor ===" -ForegroundColor Green
Write-Host ""
Write-Host "Monitoring SSH connections..." -ForegroundColor Cyan
Write-Host "This script will run until you successfully connect from Termius" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop" -ForegroundColor Gray
Write-Host ""
Write-Host "Connection Details:" -ForegroundColor Cyan
Write-Host "  Host: $($config.IPAddress)" -ForegroundColor White
Write-Host "  Port: 22" -ForegroundColor White
Write-Host "  Username: $($config.Username)" -ForegroundColor White
Write-Host ""
Write-Host "Your Public Key (add this to Termius):" -ForegroundColor Cyan
Write-Host ("="*60) -ForegroundColor Gray
Write-Host $config.PublicKey -ForegroundColor White
Write-Host ("="*60) -ForegroundColor Gray
Write-Host ""

$lastConnectionCount = 0
$successCount = 0

while ($true) {
    # Check SSH service
    $service = Get-Service sshd -ErrorAction SilentlyContinue
    $serviceStatus = if ($service.Status -eq 'Running') { "RUNNING" } else { "STOPPED" }
    
    # Check port 22
    $port22 = netstat -ano | Select-String ":22" | Select-String "LISTENING"
    $portStatus = if ($port22) { "LISTENING" } else { "NOT LISTENING" }
    
    # Check active connections
    $connections = netstat -ano | Select-String ":22" | Select-String "ESTABLISHED"
    $connectionCount = if ($connections) { ($connections | Measure-Object).Count } else { 0 }
    
    # Check if new connection established
    if ($connectionCount -gt $lastConnectionCount) {
        $successCount++
        Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] SUCCESS! Connection detected! ($successCount)" -ForegroundColor Green
        Write-Host "  You should now be connected in Termius!" -ForegroundColor Green
    }
    
    $lastConnectionCount = $connectionCount
    
    # Display status
    $statusLine = "[$((Get-Date).ToString('HH:mm:ss'))] Service: $serviceStatus | Port: $portStatus | Connections: $connectionCount"
    
    if ($serviceStatus -eq "RUNNING" -and $portStatus -eq "LISTENING") {
        Write-Host $statusLine -ForegroundColor Green
    } else {
        Write-Host $statusLine -ForegroundColor Red
    }
    
    # Check for authentication issues
    if ($connectionCount -gt 0) {
        Write-Host "  Active SSH connection(s) detected!" -ForegroundColor Cyan
    }
    
    Start-Sleep -Seconds 2
}

