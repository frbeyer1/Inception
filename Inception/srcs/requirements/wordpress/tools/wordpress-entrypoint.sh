#!/bin/bash
set -e
cd /var/www/html

if [ ! -e /etc/.firstrun ]; then
    # Change the listen directive in Ubuntu's PHP-FPM config
    sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf
    touch /etc/.firstrun
fi

if [ ! -e .firstmount ]; then
    # Wait for MariaDB to be ready
    until mariadb-admin ping --protocol=tcp --host=mariadb -u "$MYSQL_USER" --password="$MYSQL_PASSWORD" --wait >/dev/null 2>&1; do
        echo "Waiting for MariaDB..."
        sleep 2
    done

    # Check if WordPress is already installed
    if [ ! -f wp-config.php ]; then
        echo "Installing WordPress..."

        wp core download --allow-root || true
        wp config create --allow-root \
            --dbhost=mariadb \
            --dbuser="$MYSQL_USER" \
            --dbpass="$MYSQL_PASSWORD" \
            --dbname="$MYSQL_DATABASE"

        wp config set WP_CACHE true --raw
        wp config set FS_METHOD direct
        wp core install --allow-root \
            --skip-email \
            --url="$DOMAIN_NAME" \
            --title="$WORDPRESS_TITLE" \
            --admin_user="$WORDPRESS_ADMIN_USER" \
            --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
            --admin_email="$WORDPRESS_ADMIN_EMAIL"

        # Create author user if it doesn't exist
        if ! wp user get "$WORDPRESS_USER" --allow-root > /dev/null 2>&1; then
            wp user create "$WORDPRESS_USER" "$WORDPRESS_EMAIL" --role=author --user_pass="$WORDPRESS_PASSWORD" --allow-root
        fi
    else
        echo "WordPress is already installed."
    fi

    chmod -R o+w /var/www/html/wp-content
    touch .firstmount
fi

# Run PHP-FPM in foreground
exec php-fpm8.2 -F
