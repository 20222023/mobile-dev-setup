# Enable SSH Key Authentication in SSH Server Config
# Run as Administrator

Write-Host "=== Enabling SSH Key Authentication ===" -ForegroundColor Green
Write-Host ""

$sshdConfig = "C:\ProgramData\ssh\sshd_config"
$backupConfig = "$sshdConfig.backup"

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select Run as Administrator" -ForegroundColor Yellow
    exit 1
}

# Backup config
if (Test-Path $sshdConfig) {
    Copy-Item $sshdConfig $backupConfig -Force
    Write-Host "Backed up SSH config" -ForegroundColor Green
}

# Read config
$config = Get-Content $sshdConfig

# Enable PubkeyAuthentication
$newConfig = @()
$pubkeyFound = $false
$passwordAuthFound = $false

foreach ($line in $config) {
    if ($line -match "^#?\s*PubkeyAuthentication") {
        $newConfig += "PubkeyAuthentication yes"
        $pubkeyFound = $true
    }
    elseif ($line -match "^#?\s*PasswordAuthentication") {
        $newConfig += "PasswordAuthentication yes"
        $passwordAuthFound = $true
    }
    else {
        $newConfig += $line
    }
}

# Add if not found
if (-not $pubkeyFound) {
    $newConfig += ""
    $newConfig += "# Enable public key authentication"
    $newConfig += "PubkeyAuthentication yes"
}

# Write config
$newConfig | Set-Content $sshdConfig -Encoding ASCII
Write-Host "Updated SSH config to enable key authentication" -ForegroundColor Green

# Restart SSH service
Write-Host ""
Write-Host "Restarting SSH service..." -ForegroundColor Cyan
try {
    Restart-Service sshd
    Write-Host "SSH service restarted" -ForegroundColor Green
} catch {
    Write-Host "Failed to restart service: $_" -ForegroundColor Red
    Write-Host "Try manually: Restart-Service sshd" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Done! ===" -ForegroundColor Green
Write-Host ""
Write-Host "SSH key authentication is now enabled." -ForegroundColor Cyan
Write-Host "Try connecting from Termius again with your SSH key." -ForegroundColor Yellow
