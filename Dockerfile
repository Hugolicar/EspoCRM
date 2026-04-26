FROM php:8.1-apache

# Instala dependencias do sistema + libpq-dev para PostgreSQL
RUN apt-get update && apt-get install -y \
    unzip curl \
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

EXPOSE 80
CMD ["apache2-foreground"]
