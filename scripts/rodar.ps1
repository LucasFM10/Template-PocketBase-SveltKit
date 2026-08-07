# ============================================================
# Script Principal — Rodar o Monorepo (Com auto-configuração)
# ============================================================
# Uso:
#   .\scripts\rodar.ps1          (Tenta Docker, fallback para sem Docker)
#   .\scripts\rodar.ps1 -SemDocker (Força modo sem Docker)
# ============================================================

param(
    [switch]$SemDocker
)

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."

# 1. AUTO-SETUP: Prepara arquivos .env se não existirem
$WebEnv = "$ProjectRoot\apps\web\.env"
$WebEnvEx = "$ProjectRoot\apps\web\.env.example"
if (-not (Test-Path $WebEnv) -and (Test-Path $WebEnvEx)) {
    Copy-Item $WebEnvEx $WebEnv
    Write-Host "✅ Arquivo apps/web/.env criado automaticamente." -ForegroundColor Green
}

$PbEnv = "$ProjectRoot\apps\pocketbase\.env"
$PbEnvEx = "$ProjectRoot\apps\pocketbase\.env.example"
if (-not (Test-Path $PbEnv) -and (Test-Path $PbEnvEx)) {
    Copy-Item $PbEnvEx $PbEnv
    Write-Host "✅ Arquivo apps/pocketbase/.env criado automaticamente." -ForegroundColor Green
}

# 2. AUTO-SETUP: Instala dependências do SvelteKit se necessário
$NodeModules = "$ProjectRoot\apps\web\node_modules"
if (-not (Test-Path $NodeModules)) {
    Write-Host "📦 Primeira execução detectada! Instalando dependências..." -ForegroundColor Yellow
    Set-Location "$ProjectRoot\apps\web"
    npm install
    Set-Location $ProjectRoot
}

if ($SemDocker) {
    & "$PSScriptRoot\rodar-sem-docker.ps1"
    exit
}

# 3. Execução via Docker
Write-Host "`n🐳 Iniciando projeto via Docker Compose..." -ForegroundColor Cyan
Set-Location $ProjectRoot

try {
    docker compose up --build
} catch {
    Write-Host "`n⚠️ Falha ao iniciar via Docker. Alternando para modo sem Docker..." -ForegroundColor Red
    & "$PSScriptRoot\rodar-sem-docker.ps1"
}
