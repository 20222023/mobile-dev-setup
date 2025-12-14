# Fix SSH password prompt issue
# This ensures key authentication is properly configured

Write-Host "=== Fixing SSH Key Authentication ===" -ForegroundColor Green
Write-Host ""

# Check authorized_keys
$authorizedKeys = "$env:USERPROFILE\.ssh\authorized_keys"
Write-Host "1. Checking authorized_keys file..." -ForegroundColor Cyan
if (Test-Path $authorizedKeys) {
    $content = Get-Content $authorizedKeys
    if ($content) {
        Write-Host "   ✓ File exists with content" -ForegroundColor Green
        Write-Host "   Key count: $($content.Count)" -ForegroundColor Gray
    } else {
        Write-Host "   ✗ File exists but is empty" -ForegroundColor Red
    }
} else {
    Write-Host "   ✗ File does not exist" -ForegroundColor Red
    Write-Host "   Creating and adding key..." -ForegroundColor Yellow
    
    # Recreate authorized_keys
    $publicKey = Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"
    $publicKey | Out-File -FilePath $authorizedKeys -Encoding ASCII
    Write-Host "   ✓ Created and added key" -ForegroundColor Green
}

# Fix permissions
Write-Host ""
Write-Host "2. Fixing permissions..." -ForegroundColor Cyan
try {
    # Remove inheritance
    icacls $authorizedKeys /inheritance:r | Out-Null
    # Grant full control to user
    icacls $authorizedKeys /grant "${env:USERNAME}:F" | Out-Null
    Write-Host "   ✓ Permissions set correctly" -ForegroundColor Green
} catch {
    Write-Host "   ⚠ Could not set permissions: $_" -ForegroundColor Yellow
}

# Check SSH config
Write-Host ""
Write-Host "3. Checking SSH server configuration..." -ForegroundColor Cyan
$sshdConfig = "C:\ProgramData\ssh\sshd_config"
if (Test-Path $sshdConfig) {
    $config = Get-Content $sshdConfig
    $pubkeyAuth = $config | Select-String "PubkeyAuthentication"
    $passwordAuth = $config | Select-String "PasswordAuthentication"
    $authKeysFile = $config | Select-String "AuthorizedKeysFile"
    
    Write-Host "   PubkeyAuthentication: $($pubkeyAuth -join ', ')" -ForegroundColor Gray
    Write-Host "   PasswordAuthentication: $($passwordAuth -join ', ')" -ForegroundColor Gray
    Write-Host "   AuthorizedKeysFile: $($authKeysFile -join ', ')" -ForegroundColor Gray
    
    # Check if PubkeyAuthentication is enabled
    if ($pubkeyAuth -and $pubkeyAuth -notmatch "yes|^[^#]*PubkeyAuthentication\s+yes") {
        Write-Host "   ⚠ PubkeyAuthentication might be disabled" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⚠ SSH config file not found" -ForegroundColor Yellow
}

# Restart SSH service
Write-Host ""
Write-Host "4. Restarting SSH service..." -ForegroundColor Cyan
try {
    Restart-Service sshd -ErrorAction Stop
    Write-Host "   ✓ SSH service restarted" -ForegroundColor Green
} catch {
    Write-Host "   ⚠ Could not restart service: $_" -ForegroundColor Yellow
    Write-Host "   → Run as Administrator to restart service" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Green
Write-Host ""
Write-Host "If still asking for password, check in Termius:" -ForegroundColor Yellow
Write-Host "1. Make sure you selected 'Use Key' (not password)" -ForegroundColor White
Write-Host "2. The key is added to Termius Settings → SSH Keys" -ForegroundColor White
Write-Host "3. When adding host, Authentication method is set to 'Key'" -ForegroundColor White
Write-Host ""
Write-Host "Your public key:" -ForegroundColor Cyan
Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"

