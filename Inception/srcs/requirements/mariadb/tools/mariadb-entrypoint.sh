#!/bin/bash
set -e

# First run config to bind on 0.0.0.0
if [ ! -e /etc/.firstrun ]; then
    echo "[mysqld]" >> /etc/mysql/mariadb.conf.d/50-server.cnf
    echo "bind-address = 0.0.0.0" >> /etc/mysql/mariadb.conf.d/50-server.cnf
    echo "skip-networking = 0" >> /etc/mysql/mariadb.conf.d/50-server.cnf
    touch /etc/.firstrun
fi

# Ensure required dirs exist
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize DB if first mount
if [ ! -e /var/lib/mysql/.firstmount ]; then
    echo "Initializing database..."
    # Start the MariaDB server in the background
    mysqld_safe &
    mysqld_pid=$!

    echo "Waiting for MariaDB to be ready..."
    until mysqladmin ping --silent; do
        sleep 1
    done

    # Force mysql_upgrade to run with --force
    mysql_upgrade --user=root --password=${MYSQL_ROOT_PASSWORD} --force

    echo "Starting MariaDB in the background..."
    mysqld_safe &
    mysqld_pid=$!

    echo "Setting up database and user..."
    cat << EOF | mysql --protocol=socket -u root --password=${MYSQL_ROOT_PASSWORD}
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; 
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
UPDATE mysql.user SET host='%' WHERE user='root';
FLUSH PRIVILEGES;
EOF

    echo "Shutting down temporary server..."
    mysqladmin shutdown

    touch /var/lib/mysql/.firstmount
fi

# Start the server in foreground
exec mysqld_safe
