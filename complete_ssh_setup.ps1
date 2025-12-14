# Complete SSH Setup with File-Based Configuration
# Run as Administrator

Write-Host "=== Complete SSH Setup ===" -ForegroundColor Green
Write-Host ""

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: Must run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell -> Run as Administrator" -ForegroundColor Yellow
    exit 1
}

# Configuration file
$configFile = "ssh_config.json"
$sshDir = "$env:USERPROFILE\.ssh"
$authorizedKeys = "$sshDir\authorized_keys"
$sshdConfig = "C:\ProgramData\ssh\sshd_config"

# Get network info
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*"} | Select-Object -First 1).IPAddress
$username = $env:USERNAME

Write-Host "1. Ensuring SSH directory exists..." -ForegroundColor Cyan
if (-not (Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
    Write-Host "   Created .ssh directory" -ForegroundColor Green
}

Write-Host ""
Write-Host "2. Generating SSH key pair..." -ForegroundColor Cyan
$privateKey = "$sshDir\id_rsa"
$publicKey = "$sshDir\id_rsa.pub"

if (-not (Test-Path $publicKey)) {
    ssh-keygen -t rsa -b 4096 -f $privateKey -N '""' -C "$username@$(hostname)" -q
    Write-Host "   SSH key generated" -ForegroundColor Green
} else {
    Write-Host "   SSH key already exists" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "3. Setting up authorized_keys..." -ForegroundColor Cyan
$pubKeyContent = Get-Content $publicKey -Raw

if (Test-Path $authorizedKeys) {
    $existing = Get-Content $authorizedKeys -Raw
    if ($existing -notmatch [regex]::Escape($pubKeyContent.Trim())) {
        Add-Content -Path $authorizedKeys -Value $pubKeyContent.Trim()
        Write-Host "   Added key to authorized_keys" -ForegroundColor Green
    } else {
        Write-Host "   Key already in authorized_keys" -ForegroundColor Yellow
    }
} else {
    $pubKeyContent.Trim() | Out-File -FilePath $authorizedKeys -Encoding ASCII -NoNewline
    Write-Host "   Created authorized_keys with key" -ForegroundColor Green
}

# Fix permissions
icacls $authorizedKeys /inheritance:r | Out-Null
icacls $authorizedKeys /grant "${username}:F" | Out-Null
Write-Host "   Fixed permissions" -ForegroundColor Green

Write-Host ""
Write-Host "4. Configuring SSH server..." -ForegroundColor Cyan
if (Test-Path $sshdConfig) {
    $config = Get-Content $sshdConfig
    $newConfig = @()
    $pubkeyEnabled = $false
    
    foreach ($line in $config) {
        if ($line -match "^#?\s*PubkeyAuthentication") {
            $newConfig += "PubkeyAuthentication yes"
            $pubkeyEnabled = $true
        } elseif ($line -match "^#?\s*PasswordAuthentication") {
            $newConfig += "PasswordAuthentication yes"
        } else {
            $newConfig += $line
        }
    }
    
    if (-not $pubkeyEnabled) {
        $newConfig += ""
        $newConfig += "# Enable public key authentication"
        $newConfig += "PubkeyAuthentication yes"
    }
    
    $newConfig | Set-Content $sshdConfig -Encoding ASCII
    Write-Host "   SSH config updated" -ForegroundColor Green
}

Write-Host ""
Write-Host "5. Restarting SSH service..." -ForegroundColor Cyan
Restart-Service sshd -ErrorAction Stop
Write-Host "   SSH service restarted" -ForegroundColor Green

Write-Host ""
Write-Host "6. Saving configuration..." -ForegroundColor Cyan
$configData = @{
    IPAddress = $ipAddress
    Port = 22
    Username = $username
    PublicKey = (Get-Content $publicKey -Raw).Trim()
    PrivateKeyPath = $privateKey
    PublicKeyPath = $publicKey
    AuthorizedKeysPath = $authorizedKeys
    SetupDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

$configData | ConvertTo-Json | Out-File -FilePath $configFile -Encoding UTF8
Write-Host "   Configuration saved to $configFile" -ForegroundColor Green

Write-Host ""
Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Connection Details:" -ForegroundColor Cyan
Write-Host "  Host: $ipAddress" -ForegroundColor White
Write-Host "  Port: 22" -ForegroundColor White
Write-Host "  Username: $username" -ForegroundColor White
Write-Host ""
Write-Host "Your Public Key (copy to Termius):" -ForegroundColor Cyan
Write-Host ("="*60) -ForegroundColor Gray
Write-Host $configData.PublicKey -ForegroundColor White
Write-Host ("="*60) -ForegroundColor Gray

