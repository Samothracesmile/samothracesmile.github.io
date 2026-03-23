# Deploy to GitHub Pages
# Run: Right-click → "Run with PowerShell"  OR  .\deploy.ps1

Set-Location $PSScriptRoot

$Host.UI.RawUI.WindowTitle = "Deploy to GitHub Pages"

function Write-Color($text, $color = "White") {
    Write-Host $text -ForegroundColor $color
}

Write-Host ""
Write-Color "  ╔══════════════════════════════════╗" Cyan
Write-Color "  ║   Deploy to GitHub Pages         ║" Cyan
Write-Color "  ╚══════════════════════════════════╝" Cyan
Write-Host ""

# Check for changes
$status = git status --short
if (-not $status) {
    Write-Color "  [!] Nothing to commit. Already up to date." Yellow
    Write-Host ""
    Read-Host "  Press Enter to exit"
    exit 0
}

# Show what changed
Write-Color "  Changes detected:" Yellow
$status | ForEach-Object { Write-Host "    $_" }
Write-Host ""

# Commit message
$msg = Read-Host "  Commit message (Enter = auto timestamp)"
if ([string]::IsNullOrWhiteSpace($msg)) {
    $msg = "Update $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

Write-Host ""
Write-Color "  Committing: $msg" White

git add -A
git commit -m $msg

Write-Host ""
Write-Color "  Pushing to GitHub..." Cyan
git push origin main

Write-Host ""
if ($LASTEXITCODE -eq 0) {
    Write-Color "  [OK] Done! Site will be live shortly at:" Green
    Write-Color "       https://samothracesmile.github.io" Green
} else {
    Write-Color "  [ERR] Push failed. Check your connection or credentials." Red
}

Write-Host ""
Read-Host "  Press Enter to exit"
