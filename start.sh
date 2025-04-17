#!/bin/bash

# Garante que o PORT está presente
PORT=${PORT:-3000}

echo "Iniciando Rails na porta $PORT"
bundle exec rails server -b 0.0.0.0 -p $PORT
