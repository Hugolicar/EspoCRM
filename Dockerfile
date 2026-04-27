FROM php:8.2-apache

# Instala dependencias do sistema + cron
RUN apt-get update && apt-get install -y \
    unzip curl cron \
    libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libxml2-dev libcurl4-openssl-dev \
    libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_pgsql pdo_mysql zip gd mbstring xml curl \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Baixa e instala o EspoCRM
RUN curl -L https://github.com/espocrm/espocrm/releases/download/9.1.5/EspoCRM-9.1.5.zip -o /tmp/espocrm.zip \
    && unzip /tmp/espocrm.zip -d /tmp/espocrm \
    && cp -r "/tmp/espocrm/EspoCRM-9.1.5/." /var/www/html/ \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/data \
    && chmod -R 775 /var/www/html/custom \
    && rm -rf /tmp/espocrm /tmp/espocrm.zip

# Configura Apache para permitir .htaccess
RUN echo '<Directory /var/www/html>\n    AllowOverride All\n    Require all granted\n</Directory>' \
    > /etc/apache2/conf-available/espocrm.conf \
    && a2enconf espocrm

# Configura crontab para tarefas agendadas do EspoCRM
RUN echo '* * * * * www-data cd /var/www/html; /usr/local/bin/php -f cron.php > /dev/null 2>&1' \
    > /etc/cron.d/espocrm \
    && chmod 0644 /etc/cron.d/espocrm \
    && crontab /etc/cron.d/espocrm

# Script de inicializacao que sobe cron + apache
RUN echo '#!/bin/bash\nservice cron start\napache2-foreground' > /start.sh \
    && chmod +x /start.sh

EXPOSE 80
CMD ["/start.sh"]
