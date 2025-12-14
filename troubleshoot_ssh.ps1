# Comprehensive SSH Troubleshooting Script
# Run this to diagnose SSH connection issues

Write-Host "=== SSH Troubleshooting ===" -ForegroundColor Green
Write-Host ""

# Check 1: OpenSSH Server Installation
Write-Host "1. Checking OpenSSH Server installation..." -ForegroundColor Cyan
try {
    $sshCap = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
    if ($sshCap) {
        if ($sshCap.State -eq 'Installed') {
            Write-Host "   ✓ OpenSSH Server is INSTALLED" -ForegroundColor Green
        } else {
            Write-Host "   ✗ OpenSSH Server is NOT INSTALLED (State: $($sshCap.State))" -ForegroundColor Red
            Write-Host "   → Install via: Settings → Apps → Optional Features → OpenSSH Server" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   ✗ OpenSSH Server capability not found" -ForegroundColor Red
        Write-Host "   → Install via: Settings → Apps → Optional Features → OpenSSH Server" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ⚠ Cannot check (requires admin): $_" -ForegroundColor Yellow
}

Write-Host ""

# Check 2: SSH Service Status
Write-Host "2. Checking SSH Service..." -ForegroundColor Cyan
$sshService = Get-Service sshd -ErrorAction SilentlyContinue
if ($sshService) {
    Write-Host "   Service exists: ✓" -ForegroundColor Green
    Write-Host "   Status: $($sshService.Status)" -ForegroundColor $(if ($sshService.Status -eq 'Running') { 'Green' } else { 'Red' })
    Write-Host "   Start Type: $($sshService.StartType)" -ForegroundColor Gray
    
    if ($sshService.Status -ne 'Running') {
        Write-Host "   → Service is NOT RUNNING" -ForegroundColor Red
        Write-Host "   → Start it with: Start-Service sshd" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ✗ SSH Service not found" -ForegroundColor Red
    Write-Host "   → OpenSSH Server may not be installed" -ForegroundColor Yellow
}

Write-Host ""

# Check 3: Firewall Rule
Write-Host "3. Checking Firewall Rule..." -ForegroundColor Cyan
$firewallRule = Get-NetFirewallRule -Name sshd -ErrorAction SilentlyContinue
if ($firewallRule) {
    Write-Host "   Firewall rule exists: ✓" -ForegroundColor Green
    Write-Host "   Enabled: $($firewallRule.Enabled)" -ForegroundColor $(if ($firewallRule.Enabled) { 'Green' } else { 'Red' })
    Write-Host "   Direction: $($firewallRule.Direction)" -ForegroundColor Gray
    Write-Host "   Action: $($firewallRule.Action)" -ForegroundColor Gray
    
    if (-not $firewallRule.Enabled) {
        Write-Host "   → Firewall rule is DISABLED" -ForegroundColor Red
        Write-Host "   → Enable it with: Enable-NetFirewallRule -Name sshd" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ✗ Firewall rule NOT FOUND" -ForegroundColor Red
    Write-Host "   → Create it with:" -ForegroundColor Yellow
    Write-Host "     New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22" -ForegroundColor White
}

Write-Host ""

# Check 4: Port 22 Listening
Write-Host "4. Checking if port 22 is listening..." -ForegroundColor Cyan
$port22 = netstat -ano | Select-String ":22" | Select-String "LISTENING"
if ($port22) {
    Write-Host "   ✓ Port 22 is LISTENING" -ForegroundColor Green
    Write-Host "   $port22" -ForegroundColor Gray
} else {
    Write-Host "   ✗ Port 22 is NOT LISTENING" -ForegroundColor Red
    Write-Host "   → SSH service may not be running" -ForegroundColor Yellow
}

Write-Host ""

# Check 5: Network Information
Write-Host "5. Network Information..." -ForegroundColor Cyan
$ipAddresses = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*"} | Select-Object IPAddress, InterfaceAlias
if ($ipAddresses) {
    Write-Host "   Your IP Address(es):" -ForegroundColor Yellow
    foreach ($ip in $ipAddresses) {
        Write-Host "   - $($ip.IPAddress) ($($ip.InterfaceAlias))" -ForegroundColor White
    }
} else {
    Write-Host "   ⚠ No network interfaces found" -ForegroundColor Yellow
}

Write-Host ""

# Check 6: Username
Write-Host "6. Connection Details..." -ForegroundColor Cyan
Write-Host "   Username: $env:USERNAME" -ForegroundColor White
Write-Host "   Password: Your Windows login password" -ForegroundColor White
Write-Host "   Port: 22" -ForegroundColor White

Write-Host ""

# Summary
Write-Host "=== Summary ===" -ForegroundColor Green
$issues = @()

if (-not $sshService -or $sshService.Status -ne 'Running') {
    $issues += "SSH Service not running"
}

if (-not $firewallRule -or -not $firewallRule.Enabled) {
    $issues += "Firewall rule missing or disabled"
}

if (-not $port22) {
    $issues += "Port 22 not listening"
}

if ($issues.Count -eq 0) {
    Write-Host "✓ SSH appears to be properly configured!" -ForegroundColor Green
    Write-Host ""
    Write-Host "If you still can't connect:" -ForegroundColor Yellow
    Write-Host "1. Make sure both devices are on the SAME Wi-Fi network" -ForegroundColor White
    Write-Host "2. Verify your Windows password is correct" -ForegroundColor White
    Write-Host "3. Try connecting from another device on the same network first" -ForegroundColor White
    Write-Host "4. Check if your router blocks local connections" -ForegroundColor White
} else {
    Write-Host "✗ Issues found:" -ForegroundColor Red
    foreach ($issue in $issues) {
        Write-Host "  - $issue" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Run these commands in Administrator PowerShell to fix:" -ForegroundColor Yellow
    if (-not $sshService -or $sshService.Status -ne 'Running') {
        Write-Host "  Start-Service sshd" -ForegroundColor White
        Write-Host "  Set-Service -Name sshd -StartupType 'Automatic'" -ForegroundColor White
    }
    if (-not $firewallRule -or -not $firewallRule.Enabled) {
        Write-Host "  New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22" -ForegroundColor White
    }
}

