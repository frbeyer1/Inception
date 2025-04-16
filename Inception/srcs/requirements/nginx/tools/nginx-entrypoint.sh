#!/bin/bash
set -e

# First-run SSL cert generation and config injection
if [ ! -e /etc/.firstrun ]; then
    # Generate a self-signed certificate
    openssl req -x509 -days 365 -newkey rsa:2048 -nodes \
        -out '/etc/nginx/ssl/cert.crt' \
        -keyout '/etc/nginx/ssl/cert.key' \
        -subj "/CN=$DOMAIN_NAME" \
        >/dev/null 2>/dev/null

    # Write Nginx config
    cat << EOF > /etc/nginx/sites-available/default
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name $DOMAIN_NAME;

    ssl_certificate /etc/nginx/ssl/cert.crt;
    ssl_certificate_key /etc/nginx/ssl/cert.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384';


    root /var/www/html;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ [^/]\.php(/|\$) {
        try_files \$fastcgi_script_name =404;

        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        fastcgi_split_path_info ^(.+\.php)(/.*)\$;
        include fastcgi_params;
    }
}
EOF

    touch /etc/.firstrun
fi

# Run Nginx in foreground
exec nginx -g 'daemon off;'
