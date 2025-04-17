#!/bin/bash

echo "Iniciando servidor Rails com porta: $PORT"
PORT=${PORT:-3000}

bundle exec ruby ./config.ru -p ${PORT:-3000}
