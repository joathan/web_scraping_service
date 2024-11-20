#!/bin/bash
set -e

echo "Iniciando o script de entrada..."

# Verifica se as gems estão instaladas
echo "Verificando gems..."
bundle check || bundle install

# Verifica se o banco de dados já existe
bundle exec rails db:create

# Executa as migrações
echo "Aplicando migrações..."
bundle exec rails db:migrate

echo "Iniciando o processo principal..."
exec "$@"
