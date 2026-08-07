# ============================================================
# Script de Setup Inicial — Monorepo SvelteKit + PocketBase
# ============================================================
# Execute este script logo após clonar o repositório template!
# ============================================================

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."

Write-Host "`n🚀 Configurando novo projeto Monorepo..." -ForegroundColor Cyan

# 1. Copiar .env.example para .env em apps/web se não existir
$WebEnvExample = "$ProjectRoot\apps\web\.env.example"
$WebEnvFile = "$ProjectRoot\apps\web\.env"

if (-not (Test-Path $WebEnvFile) -and (Test-Path $WebEnvExample)) {
    Copy-Item $WebEnvExample $WebEnvFile
    Write-Host "✅ Arquivo apps/web/.env criado a partir do .env.example." -ForegroundColor Green
}

# 2. Copiar .env.example para .env em apps/pocketbase se não existir
$PbEnvExample = "$ProjectRoot\apps\pocketbase\.env.example"
$PbEnvFile = "$ProjectRoot\apps\pocketbase\.env"

if (-not (Test-Path $PbEnvFile) -and (Test-Path $PbEnvExample)) {
    Copy-Item $PbEnvExample $PbEnvFile
    Write-Host "✅ Arquivo apps/pocketbase/.env criado a partir do .env.example." -ForegroundColor Green
}

# 3. Instalar dependências do Frontend
Write-Host "📦 Instalando dependências do SvelteKit em apps/web..." -ForegroundColor Yellow
Set-Location "$ProjectRoot\apps\web"
npm install

Set-Location $ProjectRoot

Write-Host "`n🎉 Setup concluído com sucesso!" -ForegroundColor Green
Write-Host "Para rodar o projeto:" -ForegroundColor White
Write-Host "  • Com Docker:   .\scripts\dev.ps1" -ForegroundColor Cyan
Write-Host "  • Sem Docker:   .\scripts\dev.ps1 -Local`n" -ForegroundColor Cyan
