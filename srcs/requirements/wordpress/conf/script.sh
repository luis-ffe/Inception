#!/bin/bash

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=mariadb --allow-root
./wp-cli.phar config set WP_CACHE_KEY_SALT 'string' --type=constant --allow-root
./wp-cli.phar config set WP_CACHE true --type=constant --raw --allow-root
./wp-cli.phar config set WP_REDIS_HOST redis --type=constant --allow-root
./wp-cli.phar config set WP_REDIS_PORT 6379 --type=constant --raw --allow-root
./wp-cli.phar core install --url=localhost --title=inception --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --allow-root
./wp-cli.phar user create guest ${WP_USER} ${WP_PASSWORD} ${WP_EMAIL} --role=subscriber --allow-root
./wp-cli.phar plugin install redis-cache --activate --allow-root
./wp-cli.phar redis enable --allow-root
php-fpm7.4 -F