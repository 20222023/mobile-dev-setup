# Get SSH Key in Termius-Compatible Format

Write-Host "=== Termius-Compatible SSH Key ===" -ForegroundColor Green
Write-Host ""

$publicKeyPath = "$env:USERPROFILE\.ssh\id_rsa.pub"

if (-not (Test-Path $publicKeyPath)) {
    Write-Host "SSH key not found!" -ForegroundColor Red
    Write-Host "Run complete_ssh_setup.ps1 first" -ForegroundColor Yellow
    exit 1
}

# Read and clean the key
$publicKey = Get-Content $publicKeyPath -Raw
$publicKey = $publicKey.Trim()

Write-Host "Copy this EXACT key (all on one line):" -ForegroundColor Cyan
Write-Host ("="*70) -ForegroundColor Gray
Write-Host $publicKey -ForegroundColor White
Write-Host ("="*70) -ForegroundColor Gray
Write-Host ""

# Save to file for easy copying
$keyFile = "termius_public_key.txt"
$publicKey | Out-File -FilePath $keyFile -Encoding ASCII -NoNewline
Write-Host "Key also saved to: $keyFile" -ForegroundColor Green
Write-Host ""

Write-Host "=== How to Add to Termius ===" -ForegroundColor Yellow
Write-Host ""
Write-Host "Method 1: Import Key (Recommended)" -ForegroundColor Cyan
Write-Host "1. Open Termius" -ForegroundColor White
Write-Host "2. Settings → SSH Keys (or Keys)" -ForegroundColor White
Write-Host "3. Tap '+' or 'Add Key'" -ForegroundColor White
Write-Host "4. Select 'Import' or 'Import Key'" -ForegroundColor White
Write-Host "5. Choose 'From Clipboard' or paste the key above" -ForegroundColor White
Write-Host "6. Name it: 'My Computer' or 'Windows PC'" -ForegroundColor White
Write-Host "7. Save" -ForegroundColor White
Write-Host ""
Write-Host "Method 2: Manual Entry" -ForegroundColor Cyan
Write-Host "1. Settings → SSH Keys → Add" -ForegroundColor White
Write-Host "2. Select 'Create New' or 'Manual Entry'" -ForegroundColor White
Write-Host "3. Paste the key in the 'Public Key' field" -ForegroundColor White
Write-Host "4. Name it and save" -ForegroundColor White
Write-Host ""
Write-Host "IMPORTANT: Copy the ENTIRE key (starts with ssh-rsa, ends with @Akhil_LOQ)" -ForegroundColor Yellow
Write-Host "Make sure there are no line breaks in the middle!" -ForegroundColor Yellow

