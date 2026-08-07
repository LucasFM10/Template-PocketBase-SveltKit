# Script Principal — Rodar o Monorepo (Orquestrador)
param(
    [switch]$SemDocker
)

if ($SemDocker) {
    & "$PSScriptRoot\rodar-sem-docker.ps1"
    exit
}

try {
    & "$PSScriptRoot\rodar-com-docker.ps1"
} catch {
    Write-Host "`n⚠️ Docker falhou ou não está ativo. Alternando para modo sem Docker..." -ForegroundColor Red
    & "$PSScriptRoot\rodar-sem-docker.ps1"
}
