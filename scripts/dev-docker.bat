@echo off
echo 🐳 Subindo PocketBase e SvelteKit via Docker Compose...
cd /d "%~dp0.."
docker compose up --build
