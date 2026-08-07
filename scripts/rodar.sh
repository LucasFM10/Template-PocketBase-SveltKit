#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT="$DIR/.."

# Auto-setup .env
[ ! -f "$PROJECT_ROOT/apps/web/.env" ] && [ -f "$PROJECT_ROOT/apps/web/.env.example" ] && cp "$PROJECT_ROOT/apps/web/.env.example" "$PROJECT_ROOT/apps/web/.env"
[ ! -f "$PROJECT_ROOT/apps/pocketbase/.env" ] && [ -f "$PROJECT_ROOT/apps/pocketbase/.env.example" ] && cp "$PROJECT_ROOT/apps/pocketbase/.env.example" "$PROJECT_ROOT/apps/pocketbase/.env"

# Auto-setup node_modules
if [ ! -d "$PROJECT_ROOT/apps/web/node_modules" ]; then
    echo "📦 Primeira execução detectada! Instalando dependências..."
    cd "$PROJECT_ROOT/apps/web" && npm install
fi

if [ "$1" == "--sem-docker" ]; then
    "$DIR/rodar-sem-docker.sh"
    exit 0
fi

echo "🐳 Iniciando projeto via Docker Compose..."
cd "$PROJECT_ROOT"
if ! docker compose up --build; then
    echo "⚠️ Docker falhou ou não está ativo. Alternando para modo sem Docker..."
    "$DIR/rodar-sem-docker.sh"
fi
