#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT="$DIR/.."

echo "🐳 Subindo PocketBase e SvelteKit via Docker Compose..."
cd "$PROJECT_ROOT"
docker compose up --build
