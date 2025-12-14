# Quick script to check SSH installation status
# Run this to see if OpenSSH Server is already installed

Write-Host "=== Checking SSH Status ===" -ForegroundColor Green
Write-Host ""

# Check if OpenSSH Server capability exists
Write-Host "Checking OpenSSH Server installation..." -ForegroundColor Cyan
try {
    $sshCap = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
    if ($sshCap) {
        Write-Host "Status: $($sshCap.State)" -ForegroundColor $(if ($sshCap.State -eq 'Installed') { 'Green' } else { 'Yellow' })
        Write-Host "Name: $($sshCap.Name)" -ForegroundColor Gray
    } else {
        Write-Host "OpenSSH Server not found in capabilities" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Cannot check (requires admin): $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Checking SSH Service..." -ForegroundColor Cyan
$sshService = Get-Service sshd -ErrorAction SilentlyContinue
if ($sshService) {
    Write-Host "Service Status: $($sshService.Status)" -ForegroundColor $(if ($sshService.Status -eq 'Running') { 'Green' } else { 'Yellow' })
    Write-Host "Start Type: $($sshService.StartType)" -ForegroundColor Gray
} else {
    Write-Host "SSH Service not found (OpenSSH Server may not be installed)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Checking Firewall Rule..." -ForegroundColor Cyan
$firewallRule = Get-NetFirewallRule -Name sshd -ErrorAction SilentlyContinue
if ($firewallRule) {
    Write-Host "Firewall Rule: EXISTS" -ForegroundColor Green
    Write-Host "Enabled: $($firewallRule.Enabled)" -ForegroundColor Gray
} else {
    Write-Host "Firewall Rule: NOT FOUND" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Green
if ($sshService -and $sshService.Status -eq 'Running' -and $firewallRule) {
    Write-Host "SSH appears to be set up and running!" -ForegroundColor Green
    $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*"} | Select-Object -First 1).IPAddress
    Write-Host ""
    Write-Host "Connect from mobile using:" -ForegroundColor Cyan
    Write-Host "  Host: $ip" -ForegroundColor White
    Write-Host "  Port: 22" -ForegroundColor White
    Write-Host "  Username: $env:USERNAME" -ForegroundColor White
} else {
    Write-Host "SSH setup is incomplete. Continue with installation." -ForegroundColor Yellow
}

