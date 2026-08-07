@echo off
cd /d "%~dp0.."

if not exist "apps\web\.env" if exist "apps\web\.env.example" copy "apps\web\.env.example" "apps\web\.env" >nul
if not exist "apps\pocketbase\.env" if exist "apps\pocketbase\.env.example" copy "apps\pocketbase\.env.example" "apps\pocketbase\.env" >nul

if not exist "apps\web\node_modules" (
    echo 📦 Primeira execucao detectada! Instalando dependencias do SvelteKit...
    cd apps\web
    call npm install
    cd /d "%~dp0.."
)

if not exist "apps\pocketbase\pocketbase.exe" (
    echo ⚠️ Executavel do PocketBase nao encontrado em apps\pocketbase\pocketbase.exe.
    echo Por favor, rode o script via PowerShell para baixar automaticamente.
    exit /b 1
)

echo 🚀 Iniciando PocketBase localmente...
start "" "apps\pocketbase\pocketbase.exe" serve --dir="apps\pocketbase\pb_data" --migrationsDir="apps\pocketbase\pb_migrations"

echo ⚡ Iniciando SvelteKit - apps/web...
cd apps\web
npm run dev
