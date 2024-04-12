#!/bin/bash

# Wait for the database to be ready
until nc -z -v -w30 $DB_HOST 3306
do
  echo "Waiting for database connection..."
  # Wait for 5 seconds before trying again
  sleep 5
done

echo "Database is up and running. Running migrations..."
# Run Laravel migrations
php artisan migrate

# Start the PHP-FPM server
exec "$@"
