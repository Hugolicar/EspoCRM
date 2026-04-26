#!/bin/bash
set -e

# Se /var/www/html estiver vazio, restaura os arquivos
if [ ! -f "/var/www/html/index.php" ]; then
    echo "Restaurando arquivos do EspoCRM..."
    cp -rn /var/www/html_backup/. /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

# Roda o entrypoint original do EspoCRM
exec /entrypoint.sh apache2-foreground
