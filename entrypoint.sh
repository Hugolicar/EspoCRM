#!/bin/bash
set -e

echo "=== Verificando arquivos em /var/www/html ==="

# Se não tiver o index.php, copia da imagem
if [ ! -f "/var/www/html/index.php" ]; then
    echo "Diretório vazio! Copiando arquivos do EspoCRM..."
    cp -rn /usr/src/espocrm/. /var/www/html/
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
    chmod -R 775 /var/www/html/data
    chmod -R 775 /var/www/html/custom
    echo "Arquivos copiados com sucesso!"
fi

echo "=== Iniciando Apache ==="
exec apache2-foreground
