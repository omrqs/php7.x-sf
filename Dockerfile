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

# blackfire agent and php lib
RUN wget -O /usr/local/bin/blackfire-agent https://packages.blackfire.io/binaries/blackfire-agent/1.27.0/blackfire-agent-linux_static_amd64 && chmod +x /usr/local/bin/blackfire-agent
RUN wget -O /usr/local/lib/php/extensions/no-debug-non-zts-20180731/blackfire.so https://packages.blackfire.io/binaries/blackfire-php/1.26.2/blackfire-php-alpine_amd64-php-73.so && chmod +x /usr/local/lib/php/extensions/no-debug-non-zts-20180731/blackfire.so && mkdir -p /var/run/blackfire/
RUN wget -O /usr/local/bin/blackfire https://packages.blackfire.io/binaries/blackfire-agent/1.27.0/blackfire-cli-linux_static_amd64 && chmod +x /usr/local/bin/blackfire

# Install Composer and global deps
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require hirak/prestissimo

# Set timezone
# RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime

WORKDIR /var/www
