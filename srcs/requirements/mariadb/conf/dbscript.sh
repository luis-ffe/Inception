#!/bin/bash

# Initialize the database if it’s not already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --ldata=/var/lib/mysql
fi

# Start MySQL in the background
mysqld_safe --skip-networking &
sleep 5  # Wait for MySQL to be ready

# Create database and user if they don’t exist
echo "CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;" | mariadb -uroot

# Start MySQL in the foreground
exec mysqld_safe
