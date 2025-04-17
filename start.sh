#!/bin/bash

PORT=${PORT:-3000}
echo "Iniciando servidor em porta $PORT com ruby config.ru"

exec bundle exec ruby config.ru -p $PORT -o 0.0.0.0
