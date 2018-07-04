FROM php:7.1-fpm

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
    nodejs \
    npm \
    ca-certificates \
    openssl \
    supervisor

RUN update-ca-certificates

RUN docker-php-ext-install -j$(nproc) zip iconv opcache pdo pdo_mysql mbstring intl json gd mcrypt bcmath pcntl \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime
RUN "date"

RUN echo 'alias sf="php bin/console"' >> ~/.bashrc
RUN echo 'alias phpunit="php bin/phpunit"' >> ~/.bashrc

WORKDIR /var/www
