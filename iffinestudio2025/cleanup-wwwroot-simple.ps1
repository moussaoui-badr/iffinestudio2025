# Script de nettoyage wwwroot
$wwwrootPath = "c:\Users\Badr-EddineMOUSSAOUI\source\repos\iffinestudio2025\iffinestudio2025\wwwroot"
$backupPath = "c:\Users\Badr-EddineMOUSSAOUI\source\repos\iffinestudio2025\wwwroot_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

Write-Host "=== NETTOYAGE WWWROOT ===" -ForegroundColor Cyan

# Etape 1 : Sauvegarde
Write-Host "1. Creation de la sauvegarde..." -ForegroundColor Yellow
Copy-Item -Path $wwwrootPath -Destination $backupPath -Recurse -Force
Write-Host "   OK - Sauvegarde creee" -ForegroundColor Green

# Etape 2 : Supprimer CDN
Write-Host "2. Suppression des CDN..." -ForegroundColor Yellow
Remove-Item -Path "$wwwrootPath\cdn.jsdelivr.net" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$wwwrootPath\cdnjs.cloudflare.com" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "   OK - CDN supprimes" -ForegroundColor Green

# Etape 3 : Supprimer plugins
Write-Host "3. Suppression des plugins..." -ForegroundColor Yellow
Remove-Item -Path "$wwwrootPath\wp-content\plugins" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "   OK - Plugins supprimes" -ForegroundColor Green

# Etape 4 : Supprimer themes
Write-Host "4. Suppression des themes..." -ForegroundColor Yellow
Remove-Item -Path "$wwwrootPath\wp-content\themes" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "   OK - Themes supprimes" -ForegroundColor Green

# Etape 5 : Calculer nouvelle taille
Write-Host "5. Calcul de la taille..." -ForegroundColor Yellow
$newSize = (Get-ChildItem -Path $wwwrootPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB
$newSizeRounded = [math]::Round($newSize, 2)
Write-Host "   Nouvelle taille : $newSizeRounded MB" -ForegroundColor Green

Write-Host "`n=== FIN ===" -ForegroundColor Cyan
Write-Host "Sauvegarde : $backupPath" -ForegroundColor White
Write-Host "Taille finale : $newSizeRounded MB" -ForegroundColor White
