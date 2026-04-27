#!/bin/bash
set -e

# Remove config.php se existir para forcar o wizard
rm -f /var/www/html/data/config.php

# Corrige permissoes
chown -R www-data:www-data /var/www/html/data
chmod -R 775 /var/www/html/data

# Inicia cron
service cron start

# Inicia Apache
exec apache2-foreground
