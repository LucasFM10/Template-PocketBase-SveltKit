@echo off
echo 🚀 Iniciando PocketBase localmente (sem Docker)...
cd /d "%~dp0.."

if not exist "apps\pocketbase\pocketbase.exe" (
    echo ⚠️ Executavel do PocketBase nao encontrado em apps\pocketbase\pocketbase.exe
    exit /b 1
)

start "" "apps\pocketbase\pocketbase.exe" serve --dir="apps\pocketbase\pb_data" --migrationsDir="apps\pocketbase\pb_migrations"

echo ⚡ Iniciando SvelteKit (apps/web)...
cd apps\web
npm run dev
