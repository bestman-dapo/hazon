# Add PHP-FPM base image
FROM php:8.2-fpm

ENV COMPOSER_ALLOW_SUPERUSER=1

# Install required dependencies
RUN apt-get update && \
    apt-get install -y --fix-missing \
    libzip-dev \
    zip \
    unzip \
    nano \
    curl \
    cron \
    dos2unix
    
# Install your extensions
# To connect to MySQL, add mysqli
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Install the required version of Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/hazon

# Copy app files
COPY . /var/www/hazon

# Install dependencies
RUN composer install --prefer-dist --no-interaction

# Set file permissions
RUN chown -R www-data:www-data /var/www/hazon/storage /var/www/hazon/bootstrap/cache /var/www
RUN chmod -R 775 /var/www/hazon/storage /var/www/hazon/bootstrap/cache /var/www

# Do house-keeping
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan key:generate 