# Pull base image
FROM php:7.1.9-fpm

RUN buildDeps=" \
        libbz2-dev \
        libmemcached-dev \
        libmysqlclient-dev \
        libsasl2-dev \
    " \
    runtimeDeps=" \
        curl \
        git \
        gettext \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libmemcachedutil2 \
        libpng12-dev \
        libpq-dev \
        libxml2-dev \
    " \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    && printf "no\n" | pecl install mongodb \
    && echo "extension=mongodb.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"` \
    && docker-php-ext-install iconv intl mbstring opcache pdo_mysql pdo_pgsql pgsql \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /var/lib/apt/lists/*

## Install Composer.
ENV COMPOSER_HOME /root/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

# Deploy scripts/configurations
COPY bin/*.sh /opt/docker/provision/entrypoint.d/

RUN \
    # Custom provisions
    chmod +x /opt/docker/provision/entrypoint.d/*.sh \
    && /opt/docker/provision/entrypoint.d/*.sh
