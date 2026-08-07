#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT="$DIR/.."

echo "🚀 Configurando novo projeto Monorepo..."

if [ ! -f "$PROJECT_ROOT/apps/web/.env" ] && [ -f "$PROJECT_ROOT/apps/web/.env.example" ]; then
    cp "$PROJECT_ROOT/apps/web/.env.example" "$PROJECT_ROOT/apps/web/.env"
    echo "✅ Arquivo apps/web/.env criado a partir do .env.example."
fi

echo "📦 Instalando dependências do SvelteKit..."
cd "$PROJECT_ROOT/apps/web"
npm install

echo ""
echo "🎉 Setup concluído com sucesso!"
echo "Para rodar o projeto:"
echo "  • Com Docker:   ./scripts/dev.sh"
echo "  • Sem Docker:   ./scripts/dev-local.sh"
