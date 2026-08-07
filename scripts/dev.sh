#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT="$DIR/.."

if [ "$1" == "--local" ]; then
    "$DIR/dev-local.sh"
    exit 0
fi

echo "🐳 Iniciando projeto via Docker Compose..."
cd "$PROJECT_ROOT"
if ! docker compose up --build; then
    echo "⚠️ Docker falhou ou não está ativo. Alternando para modo LOCAL..."
    "$DIR/dev-local.sh"
fi
