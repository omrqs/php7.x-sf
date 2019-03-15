FROM php:7.3-alpine

RUN apk add --update \
    tzdata \
    vim \
    git \
    unzip \
    wget \
    gnupg \
    icu-dev \
    libpng-dev \
    jpeg-dev \
    libmcrypt-dev \
    libzip-dev \
    zlib-dev \
    logrotate \
    ca-certificates \
    supervisor

RUN update-ca-certificates && apk add openssl

RUN docker-php-ext-install iconv pdo pdo_mysql mbstring intl json gd zip bcmath

# Install Composer and global deps
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require hirak/prestissimo

# Set timezone
# RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime

WORKDIR /var/www
