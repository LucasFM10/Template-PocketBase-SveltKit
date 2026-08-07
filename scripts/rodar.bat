@echo off
cd /d "%~dp0.."

if not exist "apps\web\.env" (
    if exist "apps\web\.env.example" copy "apps\web\.env.example" "apps\web\.env" >nul
)

if not exist "apps\pocketbase\.env" (
    if exist "apps\pocketbase\.env.example" copy "apps\pocketbase\.env.example" "apps\pocketbase\.env" >nul
)

if not exist "apps\web\node_modules" (
    echo 📦 Primeira execução detectada! Instalando dependencias do SvelteKit...
    cd apps\web
    call npm install
    cd /d "%~dp0.."
)

echo 🐳 Iniciando projeto via Docker Compose...
docker compose up --build
if %errorlevel% neq 0 (
    echo.
    echo ⚠️ Docker nao esta rodando ou falhou. Alternando para modo sem Docker...
    call "%~dp0rodar-sem-docker.bat"
)
