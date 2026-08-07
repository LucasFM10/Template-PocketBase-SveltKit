# Script para rodar o projeto especificamente via Docker Compose

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
Set-Location $ProjectRoot

# Auto-setup .env
$WebEnv = "$ProjectRoot\apps\web\.env"
$WebEnvEx = "$ProjectRoot\apps\web\.env.example"
if (-not (Test-Path $WebEnv) -and (Test-Path $WebEnvEx)) { Copy-Item $WebEnvEx $WebEnv }

$PbEnv = "$ProjectRoot\apps\pocketbase\.env"
$PbEnvEx = "$ProjectRoot\apps\pocketbase\.env.example"
if (-not (Test-Path $PbEnv) -and (Test-Path $PbEnvEx)) { Copy-Item $PbEnvEx $PbEnv }

Write-Host "🐳 Subindo PocketBase e SvelteKit no Docker..." -ForegroundColor Cyan
docker compose up --build
