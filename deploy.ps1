param(
  [string]$Message = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Move to this script's directory (works even if you run it from elsewhere)
Set-Location -LiteralPath $PSScriptRoot

if ([string]::IsNullOrWhiteSpace($Message)) {
  $Message = "Update " + (Get-Date -Format "yyyy-MM-dd HH:mm")
}

Write-Host "== Dev Log deploy ==" -ForegroundColor Cyan
Write-Host "Repo: $PSScriptRoot" -ForegroundColor DarkGray

# Show status (optional)
git status

# Stage + commit (only if there are changes)
git add -A

$hasChanges = (git status --porcelain).Length -gt 0
if ($hasChanges) {
  git commit -m $Message
  Write-Host "Committed: $Message" -ForegroundColor Green
} else {
  Write-Host "No local changes to commit." -ForegroundColor Yellow
}

# Rebase onto remote main, then push
Write-Host "Pulling (rebase)..." -ForegroundColor Cyan
git pull origin main --rebase

Write-Host "Pushing..." -ForegroundColor Cyan
git push

Write-Host "Done ✅" -ForegroundColor Green