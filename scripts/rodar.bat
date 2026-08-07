@echo off
chcp 65001 >nul
if "%1"=="--sem-docker" goto semdocker

call "%~dp0rodar-com-docker.bat"
if %errorlevel% neq 0 (
    echo.
    echo ⚠️ Docker nao esta rodando. Alternando para modo sem Docker...
    call "%~dp0rodar-sem-docker.bat"
)
exit /b

:semdocker
call "%~dp0rodar-sem-docker.bat"
