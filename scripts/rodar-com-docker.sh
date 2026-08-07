#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT="$DIR/.."

[ ! -f "$PROJECT_ROOT/apps/web/.env" ] && [ -f "$PROJECT_ROOT/apps/web/.env.example" ] && cp "$PROJECT_ROOT/apps/web/.env.example" "$PROJECT_ROOT/apps/web/.env"
[ ! -f "$PROJECT_ROOT/apps/pocketbase/.env" ] && [ -f "$PROJECT_ROOT/apps/pocketbase/.env.example" ] && cp "$PROJECT_ROOT/apps/pocketbase/.env.example" "$PROJECT_ROOT/apps/pocketbase/.env"

echo "🐳 Subindo PocketBase e SvelteKit via Docker Compose..."
cd "$PROJECT_ROOT"
docker compose up --build
