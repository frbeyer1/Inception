#!/bin/bash
set -e #exit if a command fails

#configure server to be reacheable by other containers on fist run
if [ ! -e /etc/.firstrun ]; then #checks if file exists
    cat  << EOF >> /etc/my.cnf.d/mariadb-server.cnf
[mysqld] 
bind-address=0.0.0.0
skip-networking=0
EOF
    touch /etc/.firstrun
fi

#mount volume and create database
if [ ! -e /var/lib/mysql/.firstmount ]; then
    # initialize database on volume and start mariadb in background
    mysql_install_db --datadir=/var/lib/mysql --skip-test-db --user=mysql --group=mysql \
        --auth-root-authentication-method=socket > /dev/null 2>/dev/null
    mysqld_safe &
    mysqld_pid=$!

    # wait for mariadb to start, then setup database and accounts
    mysqladmin ping -u root --silent --wait >/dev/null 2>/dev/null
    cat << EOF | mysql --protocol=socket -u root -p=
CREATE DATABASE $MYSQL_DATABASE;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' INDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF
    #stop temporary server and mark volume as initialized
    mysqladmin shutdown
    touch /var/lib/mysql/.firstmount
fi

exec mysqld_safe