# syntax=docker/dockerfile:1.4
FROM ghcr.io/devspace69/common:latest

# Set the PHP Version
ARG PHP_VERSION="8.3"

# Install PHP
RUN \
    # Use Surys APT repository for PHP
    curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg && \
    sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
    apt update && \
    install_packages -y \
        gettext-base \
        less \
        watch \
        nano \
        patch \
        php${PHP_VERSION} \
        php${PHP_VERSION}-xdebug \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-readline \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-igbinary \
        php${PHP_VERSION}-apcu \
        php${PHP_VERSION}-imagick \
        php${PHP_VERSION}-yaml \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-mysqlnd \
        php${PHP_VERSION}-mysqli \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-bz2 \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-msgpack \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-zstd \
        php${PHP_VERSION}-redis \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-soap \
        php${PHP_VERSION}-exif \
        php${PHP_VERSION}-xsl \
        php${PHP_VERSION}-gettext \
        php${PHP_VERSION}-cgi \
        php${PHP_VERSION}-dom \
        php${PHP_VERSION}-ftp \
        php${PHP_VERSION}-iconv \
        php${PHP_VERSION}-pdo \
        php${PHP_VERSION}-simplexml \
        php${PHP_VERSION}-tokenizer \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-xmlwriter \
        php${PHP_VERSION}-xmlreader \
        php${PHP_VERSION}-fileinfo \
        php${PHP_VERSION}-uploadprogress \
        php${PHP_VERSION}-excimer \
    && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Copy modules
ARG PHP_VERSION="8.3"
COPY --link config/modules/* /etc/php/${PHP_VERSION}/mods-available/

# Copy configs
ARG PHP_VERSION="8.3"
COPY --link config/www.xdebug.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY --link config/php-fpm.conf.tmpl /etc/php/${PHP_VERSION}/fpm/php-fpm.conf.tmpl
COPY --link config/php.ini.tmpl /etc/php/${PHP_VERSION}/fpm/php.ini.tmpl

# Copy entrypoint
COPY --link config/entrypoint.sh /entrypoint.sh

# Copy command
COPY --link config/command.fpm.xdebug.sh /command.sh

# Chmod the entrypoint and command
RUN chmod +x /entrypoint.sh /command.sh

WORKDIR /app

EXPOSE 9020
ENTRYPOINT ["/entrypoint.sh"]

ARG PHP_VERSION="8.3"
ENV PHP_VERSION=${PHP_VERSION}
ARG PHP_MEMORY_LIMIT="1024M"
ENV PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT}
