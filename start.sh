#!/bin/bash

# Usa echo pra DEBUGAR
echo "PORT recebido: $PORT"

# Força o valor ser um número (fallback)
PORT=${PORT:-3000}

exec bundle exec rails server -b 0.0.0.0 -p "$PORT"
