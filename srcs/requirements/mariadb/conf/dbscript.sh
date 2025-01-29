#!/bin/bash

# Check if MariaDB system tables exist
if [ -d "/var/lib/mysql/mysql" ]; then
    echo "✅ Existing database found. Skipping initialization."
else
    echo "🚀 No existing database found. Initializing MariaDB..."
    
    # Initialize database
    mariadb-install-db --user=mysql --ldata=/var/lib/mysql
    
    # Start MariaDB temporarily in the background
    mysqld_safe --skip-networking &
    sleep 5

    # Create database and user only if they don’t exist
    echo "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
    FLUSH PRIVILEGES;" | mariadb -uroot

    # Stop temporary background MariaDB
    mysqladmin shutdown
fi

# Start MariaDB normally
exec mysqld_safe
