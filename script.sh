#!/bin/bash
set -e

# Variáveis de ambiente esperadas
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-3306}
DB_USER=${DB_USER:-root}
DB_PASSWORD=${DB_PASSWORD:-root}
DB_NAME=${DB_NAME:-app_database}

echo "Conectando ao MySQL em $DB_HOST:$DB_PORT..."

# Comando para verificar se a base de dados existe
DB_EXISTS=$(mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" -e "SHOW DATABASES LIKE '$DB_NAME';" | grep "$DB_NAME" || true)

if [ "$DB_EXISTS" == "$DB_NAME" ]; then
  echo "Banco de dados '$DB_NAME' já existe. Nenhuma ação necessária."
else
  echo "Banco de dados '$DB_NAME' não encontrado. Criando..."
  mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE $DB_NAME;"
  echo "Banco de dados '$DB_NAME' criado com sucesso!"
fi

# Continuar com o restante do processo (substituir por comandos reais)
echo "Executando comandos adicionais..."
exec "$@"
