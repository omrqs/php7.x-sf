FROM php:7.4-alpine

RUN apk add --update --no-cache $PHPIZE_DEPS \
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

RUN pecl install xdebug-2.7.2

RUN update-ca-certificates && apk add openssl

RUN docker-php-ext-install iconv pdo pdo_mysql mbstring intl json gd zip bcmath pcntl
RUN docker-php-ext-enable xdebug

# Install Composer and global deps
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require hirak/prestissimo friendsofphp/php-cs-fixer
RUN export PATH="$PATH:$HOME/.composer/vendor/bin"

# Set timezone
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime

WORKDIR /var/www