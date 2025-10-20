# ============================================
# Script de nettoyage wwwroot pour iffinestudio2025
# Objectif : Réduire de 338MB à moins de 143MB
# ============================================

$wwwrootPath = "c:\Users\Badr-EddineMOUSSAOUI\source\repos\iffinestudio2025\iffinestudio2025\wwwroot"
$backupPath = "c:\Users\Badr-EddineMOUSSAOUI\source\repos\iffinestudio2025\wwwroot_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

Write-Host "=== NETTOYAGE WWWROOT ===" -ForegroundColor Cyan
Write-Host ""

# Images utilisées dans l'application (extraites des fichiers .cshtml)
$imagesUtilisees = @(
    # _Layout.cshtml
    "wp-content/uploads/2022/12/favicon.png",
    
    # Index.cshtml
    "wp-content/uploads/2024/01/logo.png",
    "wp-content/uploads/2024/01/2.png",
    "wp-content/uploads/2024/01/1.png",
    "wp-content/uploads/2024/01/06-Meladra-3x-BC-scaled.jpg",
    "wp-content/uploads/2023/06/Marbury_ShoppeAmberInteriors-12B.gif",
    "wp-content/uploads/2024/02/9oz-X5-website.png",
    "wp-content/uploads/2022/01/Marbury_BoxwoodAvenue-12.jpg",
    "wp-content/uploads/2025/01/Roan-Iris_Website_R17.png",
    "wp-content/uploads/2025/01/Ciru-Coffee-Website-R1-16.png",
    "wp-content/uploads/2024/02/Jake-Arnold_IGPost_R1_10-v2.jpg",
    "wp-content/uploads/2023/02/Marbury_Website-BoxwoodAvenue_03-scaled.jpg",
    "wp-content/uploads/2024/04/Fetching_Fields_Website_R2-15.png",
    "wp-content/uploads/2024/02/Marbury_Altalune-Mockup_Soap-R8C1-copy-1-scaled.jpg",
    "wp-content/uploads/2023/02/Marbury_Website-LolaEarl_01.jpg",
    "wp-content/uploads/2023/02/Marbury_Website-ChristinaNoelInteriors_01-1.jpg",
    "wp-content/uploads/2025/01/Ciru-Coffee-iPhone-GIF-Website.gif",
    "wp-content/uploads/2024/02/Janessa-Leone_Website_R3-14.png",
    "wp-content/uploads/2024/04/Fetching_Fields_Website_R1-16.png",
    "wp-content/uploads/2023/02/Marbury_Website-OurPhilosophy_01-300x300.jpg",
    "wp-content/uploads/2023/08/Marbury_Journal-CommonRebrandingMistakes_01-scaled.jpg",
    "wp-content/uploads/2023/06/Marbury_Journal-HowToBecomeAnIndustryLeader.jpg",
    "wp-content/uploads/2023/09/Marbury_Journal-EmbodiedBranding-scaled.jpg",
    "wp-content/uploads/2024/02/9oz-ssamjang-website.png",
    "wp-content/uploads/2025/02/Roan-Iris-Behance-R3-13.png",
    "wp-content/uploads/2025/01/Ciru-Coffee-Website-R1-6-306x380.png",
    "wp-content/uploads/2023/02/Marbury_Website-SoundsofBliss_02-306x380.jpg",
    "wp-content/uploads/2023/02/Marbury_Website-MinnesotaRust_01-306x380.jpg",
    "wp-content/uploads/2023/02/Marbury_Website-EssentialsbyAmberLewis_01-306x380.jpg",
    "wp-content/uploads/2023/02/Marbury_Website-ChristinaNoelInteriors_01-306x380.jpg",
    "wp-content/uploads/2023/02/Marbury_Website-JakeArnold_01-1-306x380.jpg",
    "wp-content/uploads/2023/02/Marbury_Website-Altalune_01-306x380.jpg",
    
    # Contact.cshtml
    "wp-content/uploads/2022/11/marbury-logo.svg",
    "wp-content/uploads/2022/11/toa-heftiba-u4Gu0-rnCmk-unsplash-837x1024.webp"
)

# Étape 1 : Créer une sauvegarde
Write-Host "1. Création d'une sauvegarde..." -ForegroundColor Yellow
if (Test-Path $wwwrootPath) {
    Copy-Item -Path $wwwrootPath -Destination $backupPath -Recurse -Force
    Write-Host "   ✓ Sauvegarde créée : $backupPath" -ForegroundColor Green
} else {
    Write-Host "   ✗ Le dossier wwwroot n'existe pas!" -ForegroundColor Red
    exit
}

# Étape 2 : Supprimer les CDN externes (inutiles en local)
Write-Host "`n2. Suppression des CDN externes..." -ForegroundColor Yellow
$cdnsToDelete = @(
    "$wwwrootPath\cdn.jsdelivr.net",
    "$wwwrootPath\cdnjs.cloudflare.com"
)
foreach ($cdn in $cdnsToDelete) {
    if (Test-Path $cdn) {
        Remove-Item -Path $cdn -Recurse -Force
        Write-Host "   ✓ Supprimé : $cdn" -ForegroundColor Green
    }
}

# Étape 3 : Supprimer les plugins WordPress inutiles
Write-Host "`n3. Suppression des plugins WordPress..." -ForegroundColor Yellow
$pluginsPath = "$wwwrootPath\wp-content\plugins"
if (Test-Path $pluginsPath) {
    Remove-Item -Path $pluginsPath -Recurse -Force
    Write-Host "   ✓ Supprimé : $pluginsPath" -ForegroundColor Green
}

# Étape 4 : Supprimer les thèmes WordPress inutiles
Write-Host "`n4. Suppression des thèmes WordPress..." -ForegroundColor Yellow
$themesPath = "$wwwrootPath\wp-content\themes"
if (Test-Path $themesPath) {
    # On garde seulement les CSS nécessaires
    $cssToKeep = @(
        "$themesPath\marbury\_compiled-styles\blocks-min9704.css",
        "$themesPath\marbury\_compiled-styles\theme-styles-min9055.css",
        "$themesPath\marbury\_static\styles\instagramdecd.css",
        "$themesPath\marbury\_static\styles\greg-stylesdecd.css",
        "$themesPath\marbury\vanilla-styledecd.css",
        "$themesPath\marbury\style9055.css"
    )
    
    # Créer un dossier temporaire pour les CSS à garder
    $tempCssPath = "$wwwrootPath\wp-content\css-temp"
    New-Item -Path $tempCssPath -ItemType Directory -Force | Out-Null
    
    foreach ($css in $cssToKeep) {
        if (Test-Path $css) {
            $fileName = Split-Path $css -Leaf
            Copy-Item -Path $css -Destination "$tempCssPath\$fileName" -Force
        }
    }
    
    # Supprimer tous les thèmes
    Remove-Item -Path $themesPath -Recurse -Force
    Write-Host "   ✓ Supprimé : $themesPath" -ForegroundColor Green
    
    # Restaurer les CSS nécessaires
    if (Test-Path $tempCssPath) {
        New-Item -Path "$wwwrootPath\wp-content\css" -ItemType Directory -Force | Out-Null
        Move-Item -Path "$tempCssPath\*" -Destination "$wwwrootPath\wp-content\css\" -Force
        Remove-Item -Path $tempCssPath -Force
    }
}

# Étape 5 : Nettoyer les images non utilisées
Write-Host "`n5. Nettoyage des images non utilisées..." -ForegroundColor Yellow
$uploadsPath = "$wwwrootPath\wp-content\uploads"
if (Test-Path $uploadsPath) {
    # Créer un dossier temporaire pour les images à garder
    $tempImagesPath = "$wwwrootPath\wp-content\images-temp"
    New-Item -Path $tempImagesPath -ItemType Directory -Force | Out-Null
    
    $imagesConservees = 0
    foreach ($imageRelPath in $imagesUtilisees) {
        $imagePath = Join-Path $wwwrootPath $imageRelPath
        if (Test-Path $imagePath) {
            # Recréer la structure de dossiers
            $relativeDir = Split-Path $imageRelPath -Parent
            $targetDir = Join-Path $tempImagesPath ($relativeDir -replace "wp-content/uploads/", "")
            New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
            
            # Copier l'image
            $fileName = Split-Path $imagePath -Leaf
            Copy-Item -Path $imagePath -Destination (Join-Path $targetDir $fileName) -Force
            $imagesConservees++
        }
    }
    
    # Supprimer l'ancien dossier uploads
    Remove-Item -Path $uploadsPath -Recurse -Force
    
    # Restaurer les images nécessaires
    New-Item -Path $uploadsPath -ItemType Directory -Force | Out-Null
    if (Test-Path $tempImagesPath) {
        Move-Item -Path "$tempImagesPath\*" -Destination $uploadsPath -Recurse -Force
        Remove-Item -Path $tempImagesPath -Force
    }
    
    Write-Host "   ✓ Images conservées : $imagesConservees sur $($imagesUtilisees.Count)" -ForegroundColor Green
}

# Étape 6 : Calculer la nouvelle taille
Write-Host "`n6. Calcul de la nouvelle taille..." -ForegroundColor Yellow
$newSize = (Get-ChildItem -Path $wwwrootPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB
Write-Host "   ✓ Nouvelle taille : $([math]::Round($newSize, 2)) MB" -ForegroundColor Green

# Étape 7 : Résumé
Write-Host "`n=== RÉSUMÉ DU NETTOYAGE ===" -ForegroundColor Cyan
Write-Host "✓ Sauvegarde créée : $backupPath" -ForegroundColor White
Write-Host "✓ CDN externes supprimés (cdn.jsdelivr.net, cdnjs.cloudflare.com)" -ForegroundColor White
Write-Host "✓ Plugins WordPress supprimés (~0.25 MB)" -ForegroundColor White
Write-Host "✓ Thèmes WordPress nettoyés (~2 MB)" -ForegroundColor White
Write-Host "✓ Images non utilisées supprimées" -ForegroundColor White
Write-Host "`n✓ Taille finale : $([math]::Round($newSize, 2)) MB" -ForegroundColor Green

if ($newSize -gt 143) {
    Write-Host "`n⚠️  ATTENTION : La taille dépasse encore 143 MB" -ForegroundColor Yellow
    Write-Host "   Vous devrez peut-être optimiser/compresser les images conservées." -ForegroundColor Yellow
} else {
    Write-Host "`n✓ Objectif atteint! La taille est sous 143 MB" -ForegroundColor Green
}

Write-Host "`n=== FIN DU NETTOYAGE ===" -ForegroundColor Cyan
Write-Host "`nPour restaurer la sauvegarde en cas de probleme :" -ForegroundColor Yellow
Write-Host "Remove-Item -Path '$wwwrootPath' -Recurse -Force" -ForegroundColor Gray
Write-Host "Move-Item -Path '$backupPath' -Destination '$wwwrootPath'" -ForegroundColor Gray
