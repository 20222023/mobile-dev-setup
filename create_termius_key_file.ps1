# Create a properly formatted key file for Termius

$publicKeyPath = "$env:USERPROFILE\.ssh\id_rsa.pub"
$outputFile = "termius_key.txt"

if (-not (Test-Path $publicKeyPath)) {
    Write-Host "SSH key not found! Generating..." -ForegroundColor Yellow
    
    $sshDir = "$env:USERPROFILE\.ssh"
    if (-not (Test-Path $sshDir)) {
        New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
    }
    
    $privateKey = "$sshDir\id_rsa"
    ssh-keygen -t rsa -b 4096 -f $privateKey -N '""' -C "$env:USERNAME@$(hostname)" -q
}

# Read key and ensure it's on one line
$key = Get-Content $publicKeyPath -Raw
$key = $key -replace "`r`n", "" -replace "`n", "" -replace "`r", ""
$key = $key.Trim()

# Write to file
$key | Out-File -FilePath $outputFile -Encoding ASCII -NoNewline

Write-Host "Key saved to: $outputFile" -ForegroundColor Green
Write-Host ""
Write-Host "Key content:" -ForegroundColor Cyan
Write-Host ("="*70) -ForegroundColor Gray
Write-Host $key -ForegroundColor White
Write-Host ("="*70) -ForegroundColor Gray
Write-Host ""
Write-Host "You can:" -ForegroundColor Yellow
Write-Host "1. Open $outputFile and copy the key" -ForegroundColor White
Write-Host "2. Or use the key shown above" -ForegroundColor White

