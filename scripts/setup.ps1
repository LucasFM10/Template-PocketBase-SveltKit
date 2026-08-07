# ============================================================
# Script de Setup Inicial — Monorepo SvelteKit + PocketBase
# ============================================================
# Execute este script logo após clonar o repositório template!
# ============================================================

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."

Write-Host "`n🚀 Configurando novo projeto Monorepo..." -ForegroundColor Cyan

# 1. Copiar .env.example para .env se não existir
$EnvExample = "$ProjectRoot\apps\web\.env.example"
$EnvFile = "$ProjectRoot\apps\web\.env"

if (-not (Test-Path $EnvFile) -and (Test-Path $EnvExample)) {
    Copy-Item $EnvExample $EnvFile
    Write-Host "✅ Arquivo apps/web/.env criado a partir do .env.example." -ForegroundColor Green
}

# 2. Instalar dependências do Frontend
Write-Host "📦 Instalando dependências do SvelteKit em apps/web..." -ForegroundColor Yellow
Set-Location "$ProjectRoot\apps\web"
npm install

Set-Location $ProjectRoot

Write-Host "`n🎉 Setup concluído com sucesso!" -ForegroundColor Green
Write-Host "Para rodar o projeto:" -ForegroundColor White
Write-Host "  • Com Docker:   .\scripts\dev.ps1" -ForegroundColor Cyan
Write-Host "  • Sem Docker:   .\scripts\dev.ps1 -Local`n" -ForegroundColor Cyan
