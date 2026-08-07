@echo off
echo 🚀 Configurando novo projeto Monorepo...
cd /d "%~dp0.."

if not exist "apps\web\.env" (
    if exist "apps\web\.env.example" (
        copy "apps\web\.env.example" "apps\web\.env"
        echo ✅ Arquivo apps\web\.env criado a partir do .env.example.
    )
)

echo 📦 Instalando dependencias do SvelteKit...
cd apps\web
call npm install
cd /d "%~dp0.."

echo.
echo 🎉 Setup concluido com sucesso!
echo Para rodar o projeto:
echo   • Com Docker:   .\scripts\dev.bat
echo   • Sem Docker:   .\scripts\dev-local.bat
