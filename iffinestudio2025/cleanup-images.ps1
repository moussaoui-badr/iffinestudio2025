# Script de nettoyage precis des images
$wwwrootPath = "c:\Users\Badr-EddineMOUSSAOUI\source\repos\iffinestudio2025\iffinestudio2025\wwwroot"
$uploadsPath = "$wwwrootPath\wp-content\uploads"
$tempPath = "$wwwrootPath\wp-content\uploads-temp"

# Images utilisees dans l'application
$imagesUtilisees = @(
    "2022/12/favicon.png",
    "2024/01/logo.png",
    "2024/01/2.png",
    "2024/01/1.png",
    "2024/01/06-Meladra-3x-BC-scaled.jpg",
    "2023/06/Marbury_ShoppeAmberInteriors-12B.gif",
    "2024/02/9oz-X5-website.png",
    "2022/01/Marbury_BoxwoodAvenue-12.jpg",
    "2025/01/Roan-Iris_Website_R17.png",
    "2025/01/Ciru-Coffee-Website-R1-16.png",
    "2024/02/Jake-Arnold_IGPost_R1_10-v2.jpg",
    "2023/02/Marbury_Website-BoxwoodAvenue_03-scaled.jpg",
    "2024/04/Fetching_Fields_Website_R2-15.png",
    "2024/02/Marbury_Altalune-Mockup_Soap-R8C1-copy-1-scaled.jpg",
    "2023/02/Marbury_Website-LolaEarl_01.jpg",
    "2023/02/Marbury_Website-ChristinaNoelInteriors_01-1.jpg",
    "2025/01/Ciru-Coffee-iPhone-GIF-Website.gif",
    "2024/02/Janessa-Leone_Website_R3-14.png",
    "2024/04/Fetching_Fields_Website_R1-16.png",
    "2023/02/Marbury_Website-OurPhilosophy_01-300x300.jpg",
    "2023/08/Marbury_Journal-CommonRebrandingMistakes_01-scaled.jpg",
    "2023/06/Marbury_Journal-HowToBecomeAnIndustryLeader.jpg",
    "2023/09/Marbury_Journal-EmbodiedBranding-scaled.jpg",
    "2024/02/9oz-ssamjang-website.png",
    "2025/02/Roan-Iris-Behance-R3-13.png",
    "2025/01/Ciru-Coffee-Website-R1-6-306x380.png",
    "2023/02/Marbury_Website-SoundsofBliss_02-306x380.jpg",
    "2023/02/Marbury_Website-MinnesotaRust_01-306x380.jpg",
    "2023/02/Marbury_Website-EssentialsbyAmberLewis_01-306x380.jpg",
    "2023/02/Marbury_Website-ChristinaNoelInteriors_01-306x380.jpg",
    "2023/02/Marbury_Website-JakeArnold_01-1-306x380.jpg",
    "2023/02/Marbury_Website-Altalune_01-306x380.jpg",
    "2022/11/marbury-logo.svg",
    "2022/11/toa-heftiba-u4Gu0-rnCmk-unsplash-837x1024.webp"
)

Write-Host "=== NETTOYAGE DES IMAGES ===" -ForegroundColor Cyan

# Creer dossier temp
Write-Host "1. Creation du dossier temporaire..." -ForegroundColor Yellow
New-Item -Path $tempPath -ItemType Directory -Force | Out-Null

# Copier uniquement les images utilisees
Write-Host "2. Copie des images utilisees..." -ForegroundColor Yellow
$copied = 0
$notFound = 0

foreach ($imageRel in $imagesUtilisees) {
    $sourcePath = Join-Path $uploadsPath $imageRel
    if (Test-Path $sourcePath) {
        $targetDir = Split-Path (Join-Path $tempPath $imageRel) -Parent
        New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
        Copy-Item -Path $sourcePath -Destination (Join-Path $tempPath $imageRel) -Force
        $copied++
        Write-Host "   OK : $imageRel" -ForegroundColor Green
    } else {
        Write-Host "   ABSENT : $imageRel" -ForegroundColor Yellow
        $notFound++
    }
}

# Supprimer ancien dossier uploads
Write-Host "3. Suppression de l'ancien dossier uploads..." -ForegroundColor Yellow
Remove-Item -Path $uploadsPath -Recurse -Force

# Renommer temp en uploads
Write-Host "4. Restauration du dossier uploads..." -ForegroundColor Yellow
Move-Item -Path $tempPath -Destination $uploadsPath -Force

# Calculer nouvelle taille
Write-Host "5. Calcul de la taille finale..." -ForegroundColor Yellow
$newSize = (Get-ChildItem -Path $wwwrootPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB
$newSizeRounded = [math]::Round($newSize, 2)

Write-Host "`n=== RESULTAT ===" -ForegroundColor Cyan
Write-Host "Images copiees : $copied" -ForegroundColor White
Write-Host "Images non trouvees : $notFound" -ForegroundColor White
Write-Host "Taille finale : $newSizeRounded MB" -ForegroundColor Green

if ($newSizeRounded -gt 143) {
    Write-Host "`nATTENTION : Taille encore trop grande (> 143 MB)" -ForegroundColor Red
} else {
    Write-Host "`nOBJECTIF ATTEINT !" -ForegroundColor Green
}
