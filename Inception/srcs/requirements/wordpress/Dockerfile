FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common curl gnupg2 lsb-release mariadb-client \
    imagemagick ghostscript icu-devtools libicu-dev unzip \
    ca-certificates wget bash sudo

# Add PHP 8.2 repository
RUN add-apt-repository ppa:ondrej/php -y && apt-get update

# Install PHP 8.2 and extensions
RUN apt-get install -y \
    php8.2 php8.2-fpm php8.2-cli php8.2-mysql php8.2-curl php8.2-dom \
    php8.2-exif php8.2-fileinfo php8.2-intl php8.2-mbstring php8.2-opcache \
    php8.2-readline php8.2-soap php8.2-xml php8.2-zip php8.2-bcmath php8.2-gd \
    php8.2-iconv php8.2-shmop php8.2-simplexml php8.2-common php8.2-tokenizer \
    php-igbinary php-imagick

# Install WP-CLI
RUN curl -o /usr/local/bin/wp -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

# Copy entrypoint
COPY tools/wordpress-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress-entrypoint.sh

ENTRYPOINT ["wordpress-entrypoint.sh"]
