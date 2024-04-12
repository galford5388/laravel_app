#!/bin/bash

# Start NGINX in the background
nginx -g 'daemon off;' &

# Start PHP-FPM
php-fpm

# Wait for database to be ready
sleep 5

# Run migrations
#php artisan migrate
php artisan wait_db_alive && php artisan migrate --seed 