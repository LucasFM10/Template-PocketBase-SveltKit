#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ "$1" == "--sem-docker" ]; then
    "$DIR/rodar-sem-docker.sh"
    exit 0
fi

if ! "$DIR/rodar-com-docker.sh"; then
    echo "⚠️ Docker falhou ou não está ativo. Alternando para modo sem Docker..."
    "$DIR/rodar-sem-docker.sh"
fi
