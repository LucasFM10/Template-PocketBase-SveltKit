# Script para rodar o Monorepo localmente SEM Docker (PocketBase.exe + SvelteKit)

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$PbExe = "$ProjectRoot\apps\pocketbase\pocketbase.exe"
$PbData = "$ProjectRoot\apps\pocketbase\pb_data"
$PbMigrations = "$ProjectRoot\apps\pocketbase\pb_migrations"

if (-not (Test-Path $PbExe)) {
    Write-Host "⚠️ Executável do PocketBase não encontrado em: $PbExe" -ForegroundColor Red
    Write-Host "Baixe o binário para Windows do site oficial (pocketbase.io) e coloque em apps/pocketbase/pocketbase.exe" -ForegroundColor Yellow
    exit 1
}

Write-Host "🚀 Iniciando o PocketBase localmente..." -ForegroundColor Cyan
$pbProcess = Start-Process -FilePath $PbExe -ArgumentList "serve --dir=`"$PbData`" --migrationsDir=`"$PbMigrations`"" -PassThru

Write-Host "⚡ Iniciando o SvelteKit (apps/web)..." -ForegroundColor Green
Set-Location "$ProjectRoot\apps\web"

try {
    npm run dev
} finally {
    Write-Host "🛑 Encerrando PocketBase..." -ForegroundColor Yellow
    if ($pbProcess -and -not $pbProcess.HasExited) {
        Stop-Process -Id $pbProcess.Id -Force
    }
}
