FROM php:7.2-fpm

RUN apt-get update && apt-get install -y \
    vim \
    git \
    unzip \
    libicu-dev \
    libpng-dev \
    libfreetype6-dev \
    libmcrypt-dev \
    libjpeg-dev \
    cron \
    logrotate \
    ca-certificates \
    openssl \
    wget \
    gnupg
    
# Install and configure blackfire.io
RUN wget -q -O - https://packagecloud.io/gpg.key | apt-key add -
RUN echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list
RUN apt-get update && apt-get install -y \
    blackfire-agent \
    blackfire-php

# Install supervisor
RUN apt-get install -y supervisor

# Install phpunit
RUN wget https://phar.phpunit.de/phpunit-7.phar && chmod +x phpunit-7.phar
RUN mv phpunit-7.phar /usr/local/bin/phpunit
RUN phpunit --version

RUN update-ca-certificates

# Install certbot
RUN apt-get install -y python-certbot-nginx

RUN docker-php-ext-install -j$(nproc) zip iconv opcache pdo pdo_mysql mbstring intl json gd bcmath pcntl \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Install xdebug with pecl
RUN yes | pecl install xdebug \
	&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime
RUN "date"

RUN echo 'alias sf="php bin/console"' >> ~/.bashrc

WORKDIR /var/www
