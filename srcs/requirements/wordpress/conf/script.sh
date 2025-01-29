#!/bin/bash

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

# Wait for MariaDB to be ready using netcat (nc)
while ! nc -z mariadb 3306; do
    echo "⏳ Waiting for MariaDB..."
    sleep 5
done
echo "✅ MariaDB is up!"

./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=mariadb --allow-root
./wp-cli.phar core install --url=localhost --title=inception --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --allow-root

# Create WordPress user
./wp-cli.phar user create ${WP_USER} ${WP_EMAIL} --role=subscriber --user_pass=${WP_PASSWORD} --allow-root

# Start PHP-FPM
exec php-fpm7.4 -F
