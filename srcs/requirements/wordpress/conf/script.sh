#!/bin/bash

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

# Wait for MariaDB to be ready
while ! mysqladmin ping -h"$DB_HOST" --silent; do
    sleep 5
done

./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=mariadb --allow-root
./wp-cli.phar core install --url=localhost --title=inception --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --allow-root

#./wp-cli.phar user create guest ${WP_USER} ${WP_PASSWORD} ${WP_EMAIL} --role=subscriber --allow-root
./wp-cli.phar user create ${WP_USER} ${WP_EMAIL} --role=subscriber --user_pass=${WP_PASSWORD} --allow-root

exec php-fpm7.4 -F