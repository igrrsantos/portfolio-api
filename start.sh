#!/bin/bash

echo "Iniciando servidor Rails na porta 3000 (temporário)"

bundle exec rails server -b 0.0.0.0 -p 3000
