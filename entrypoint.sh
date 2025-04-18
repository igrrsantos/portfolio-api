#!/bin/bash
set -e

# Executa as migrações apenas se o comando for 'rails s'
if [ "${*}" == "bundle exec rails s -b 0.0.0.0 -p 3000" ]; then
  bundle exec rails db:prepare || echo "Database preparation failed! Continuing anyway..."
fi

# Executa o comando principal (CMD do Dockerfile)
exec "$@"