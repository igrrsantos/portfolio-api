#!/bin/bash

echo "Iniciando servidor Rails com porta: $PORT"
PORT=${PORT:-3000}

bundle exec rails server -b 0.0.0.0 -p $PORT
