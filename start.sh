#!/bin/bash
set -e

# Gera config.php do EspoCRM usando variaveis de ambiente do Railway
if [ ! -f /var/www/html/data/config.php ]; then
    echo "Gerando config.php..."
    mkdir -p /var/www/html/data
    cat > /var/www/html/data/config.php << EOF
<?php
return [
    'database' => [
        'driver' => 'pdo_pgsql',
        'host' => 'postgres.railway.internal',
        'port' => '5432',
        'dbname' => 'railway',
        'user' => 'postgres',
        'password' => '${ESPOCRM_DATABASE_PASSWORD}',
    ],
    'siteUrl' => '${ESPOCRM_SITE_URL}',
    'defaultPermissions' => [
        'dir' => '0775',
        'file' => '0664',
        'user' => '',
        'group' => '',
    ],
    'smtpSecurity' => '',
    'logger' => [
        'path' => 'data/logs/espo.log',
        'level' => 'WARNING',
    ],
    'adminUpgradeDisabled' => false,
    'jobMaxPortion' => 15,
    'jobRunInParallel' => false,
    'jobPoolConcurrencyNumber' => 8,
    'daemonMaxProcessNumber' => 5,
    'daemonInterval' => 10,
    'daemonProcessTimeout' => 36000,
    'recordsPerPage' => 20,
    'lastViewedCount' => 20,
    'decimalMark' => '.',
    'thousandSeparator' => ',',
    'exportDelimiter' => ',',
    'calendarEntityList' => ['Meeting', 'Call', 'Task'],
    'activitiesEntityList' => ['Meeting', 'Call'],
    'historyEntityList' => ['Meeting', 'Call', 'Email'],
    'busyRangesEntityList' => ['Meeting', 'Call'],
];
EOF
    chown www-data:www-data /var/www/html/data/config.php
    chmod 664 /var/www/html/data/config.php
    echo "config.php gerado com sucesso!"
fi

# Corrige permissoes
chown -R www-data:www-data /var/www/html/data
chmod -R 775 /var/www/html/data

# Inicia cron
service cron start

# Inicia Apache
exec apache2-foreground
