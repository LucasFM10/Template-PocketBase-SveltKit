# Script para rodar TODO o Monorepo via Docker (PocketBase + SvelteKit)

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."

Write-Host "🐳 Subindo PocketBase e SvelteKit via Docker Compose..." -ForegroundColor Cyan
Set-Location $ProjectRoot
docker compose up --build
