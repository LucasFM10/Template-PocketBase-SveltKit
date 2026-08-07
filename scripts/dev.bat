@echo off
echo 🐳 Iniciando projeto via Docker Compose...
cd /d "%~dp0.."
docker compose up --build
if %errorlevel% neq 0 (
    echo.
    echo ⚠️ Docker nao esta rodando ou falhou. Alternando para modo LOCAL...
    call "%~dp0dev-local.bat"
)
