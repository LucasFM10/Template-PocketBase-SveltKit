# Script para rodar o Monorepo localmente SEM Docker (PocketBase.exe + SvelteKit)

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$PbExe = "$ProjectRoot\apps\pocketbase\pocketbase.exe"
$PbData = "$ProjectRoot\apps\pocketbase\pb_data"
$PbMigrations = "$ProjectRoot\apps\pocketbase\pb_migrations"

# Se o executável do PocketBase não existir, baixa automaticamente a versão oficial
if (-not (Test-Path $PbExe)) {
    Write-Host "📥 pocketbase.exe não encontrado em apps/pocketbase. Baixando versão v0.39.4..." -ForegroundColor Yellow
    $ZipPath = "$ProjectRoot\apps\pocketbase\pocketbase.zip"
    $Url = "https://github.com/pocketbase/pocketbase/releases/download/v0.39.4/pocketbase_0.39.4_windows_amd64.zip"
    
    try {
        Invoke-WebRequest -Uri $Url -OutFile $ZipPath
        Expand-Archive -Path $ZipPath -DestinationPath "$ProjectRoot\apps\pocketbase" -Force
        Remove-Item $ZipPath -Force
        Write-Host "✅ PocketBase baixado e extraído com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Falha ao baixar o PocketBase automaticamente. Baixe o executável em pocketbase.io e coloque em apps/pocketbase/pocketbase.exe" -ForegroundColor Red
        exit 1
    }
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
