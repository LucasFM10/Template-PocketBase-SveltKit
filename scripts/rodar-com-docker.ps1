# Script para rodar o projeto via Docker Compose (Com auto-setup)

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."

# Auto-setup .env
$WebEnv = "$ProjectRoot\apps\web\.env"
$WebEnvEx = "$ProjectRoot\apps\web\.env.example"
if (-not (Test-Path $WebEnv) -and (Test-Path $WebEnvEx)) { Copy-Item $WebEnvEx $WebEnv }

$PbEnv = "$ProjectRoot\apps\pocketbase\.env"
$PbEnvEx = "$ProjectRoot\apps\pocketbase\.env.example"
if (-not (Test-Path $PbEnv) -and (Test-Path $PbEnvEx)) { Copy-Item $PbEnvEx $PbEnv }

Write-Host "`n🐳 Subindo PocketBase e SvelteKit via Docker Compose..." -ForegroundColor Cyan
Set-Location $ProjectRoot
docker compose up --build
