# Setup SSH Key Authentication (No Password Required!)
# This allows you to connect without a Windows password

Write-Host "=== SSH Key Authentication Setup ===" -ForegroundColor Green
Write-Host ""
Write-Host "This will create an SSH key pair so you can connect without a password." -ForegroundColor Cyan
Write-Host ""

# Check if .ssh directory exists
$sshDir = "$env:USERPROFILE\.ssh"
if (-not (Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
    Write-Host "Created .ssh directory" -ForegroundColor Green
}

# Check if key already exists
$publicKeyPath = "$sshDir\id_rsa.pub"
$privateKeyPath = "$sshDir\id_rsa"

if (Test-Path $publicKeyPath) {
    Write-Host "SSH key already exists!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Your public key (copy this to your phone):" -ForegroundColor Cyan
    Write-Host ("="*60) -ForegroundColor Gray
    Get-Content $publicKeyPath
    Write-Host ("="*60) -ForegroundColor Gray
} else {
    Write-Host "Generating SSH key pair..." -ForegroundColor Cyan
    Write-Host "(Press Enter when prompted for passphrase to skip password)" -ForegroundColor Yellow
    Write-Host ""
    
    # Generate SSH key
    ssh-keygen -t rsa -b 4096 -f $privateKeyPath -N '""' -C "$env:USERNAME@$(hostname)"
    
    if (Test-Path $publicKeyPath) {
        Write-Host ""
        Write-Host "✓ SSH key generated successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Your public key (copy this to your phone):" -ForegroundColor Cyan
        Write-Host ("="*60) -ForegroundColor Gray
        Get-Content $publicKeyPath
        Write-Host ("="*60) -ForegroundColor Gray
    } else {
        Write-Host "✗ Failed to generate SSH key" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "=== Next Steps ===" -ForegroundColor Green
Write-Host ""
Write-Host "1. Copy the public key shown above" -ForegroundColor Yellow
Write-Host "2. Add it to authorized_keys:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   Run this command:" -ForegroundColor Cyan
Write-Host "   type $publicKeyPath >> $sshDir\authorized_keys" -ForegroundColor White
Write-Host ""
Write-Host "3. Set correct permissions:" -ForegroundColor Yellow
Write-Host "   icacls $sshDir\authorized_keys /inheritance:r" -ForegroundColor White
Write-Host "   icacls $sshDir\authorized_keys /grant ${env:USERNAME}:F" -ForegroundColor White
Write-Host ""
Write-Host "4. On your phone (Termius app):" -ForegroundColor Yellow
Write-Host "   - Add the public key to your SSH key list" -ForegroundColor White
Write-Host "   - When connecting, select 'Use Key' instead of password" -ForegroundColor White
Write-Host ""

