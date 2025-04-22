#Set base image to Alpine Linux 3.16
FROM alpine:3.16

#Build arguments
ARG PHP_VERSION=8 \
    DB_NAME \
    DB_USER \
    DB_PASS

#Install PHP and extensions
#Changes PHP-FPM listen address to 9000
#Sets the owner and group for the PHP-FPM socket to nobody (improves compatibility)
RUN apk update && apk upgrade && apk add --no-cache \
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-redis \
    wget \
    unzip && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" \
      /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
      /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
      /etc/php8/php-fpm.d/www.conf && \
    rm -f /var/cache/apk/*

#Set working directory
WORKDIR /var/www

#Download and extract WordPress
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    cp -rf wordpress/* . && \
    rm -rf wordpress latest.zip

#Copy the config script
COPY ./requirements/wordpress/conf/wp-config-create.sh .

##Make sure script runs and deletes it afterwards, set permissions to be fully writable
RUN sh wp-config-create.sh && rm wp-config-create.sh && \
    chmod -R 0777 wp-content/

#Starts PHP-FPM in the foreground
CMD ["/usr/sbin/php-fpm8", "-F"]
