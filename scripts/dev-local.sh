#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT="$DIR/.."

PB_BIN="$PROJECT_ROOT/apps/pocketbase/pocketbase"
PB_DATA="$PROJECT_ROOT/apps/pocketbase/pb_data"
PB_MIGRATIONS="$PROJECT_ROOT/apps/pocketbase/pb_migrations"

if [ ! -f "$PB_BIN" ]; then
    echo "⚠️ Executável do PocketBase não encontrado em $PB_BIN"
    exit 1
fi

echo "🚀 Iniciando PocketBase localmente (sem Docker)..."
"$PB_BIN" serve --dir="$PB_DATA" --migrationsDir="$PB_MIGRATIONS" &
PB_PID=$!

cleanup() {
    echo "🛑 Encerrando PocketBase..."
    kill $PB_PID 2>/dev/null || true
}
trap cleanup EXIT

echo "⚡ Iniciando SvelteKit (apps/web)..."
cd "$PROJECT_ROOT/apps/web"
npm run dev
