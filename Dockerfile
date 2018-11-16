FROM php:7.2-alpine

RUN apk add --update \
    vim \
    git \
    unzip \
    wget \
    gnupg \
    icu-dev \
    libmcrypt-dev \
    libpng-dev \
    jpeg-dev \
    zlib-dev \
    logrotate \
    ca-certificates \
    graphviz \
    supervisor

RUN update-ca-certificates && apk add openssl

RUN docker-php-ext-install iconv pdo pdo_mysql mbstring intl json gd zip bcmath

# Install phpdoc and deps
RUN wget http://phpdoc.org/phpDocumentor.phar
RUN mv phpDocumentor.phar /usr/local/bin/phpdoc
RUN chmod +x /usr/local/bin/phpdoc

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Increase composer speed
RUN composer global require hirak/prestissimo

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime

RUN echo 'alias sf="php bin/console"' >> ~/.bashrc

WORKDIR /var/www
