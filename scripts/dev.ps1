# ============================================================
# Script Único para Rodar o Projeto (Docker ou Local)
# ============================================================
# Uso:
#   .\scripts\dev.ps1         (Modo Docker por padrão)
#   .\scripts\dev.ps1 -Local  (Modo Local sem Docker)
# ============================================================

param(
    [switch]$Local
)

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."

if ($Local) {
    Write-Host "`n🚀 Executando no modo LOCAL (sem Docker)..." -ForegroundColor Yellow
    & "$PSScriptRoot\dev-local.ps1"
    exit
}

# Tenta rodar no modo Docker
Write-Host "`n🐳 Tentando iniciar via Docker Compose..." -ForegroundColor Cyan
Set-Location $ProjectRoot

try {
    docker compose up --build
} catch {
    Write-Host "`n⚠️ Falha ao iniciar via Docker. Alternando para o modo LOCAL..." -ForegroundColor Red
    & "$PSScriptRoot\dev-local.ps1"
}
