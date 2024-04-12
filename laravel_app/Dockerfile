FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    nano \
    curl \
    nginx \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create a non-root user
ARG user=laravel
ARG uid=1000
RUN adduser --disabled-password --gecos '' --uid $uid $user

# Copy only necessary files
COPY composer.json ./

# Install PHP dependencies for production
RUN composer install --no-dev --optimize-autoloader --no-plugins --no-scripts

# Copy remaining Laravel files
COPY . .

# Remove development files
RUN rm -rf .git* docker-compose.yml README.md

# Set permissions
RUN chown -R $user:$user /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod o+w /var/www/html/storage/ -R

RUN composer update

# Generate Laravel application key
RUN php artisan key:generate

# Remove default NGINX configuration
RUN rm -rf /etc/nginx/sites-enabled && rm -rf /etc/nginx/sites-available 

# Configure NGINX
COPY laravel.conf /etc/nginx/conf.d/laravel.conf
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose ports
EXPOSE 80

# Start NGINX and PHP-FPM
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
