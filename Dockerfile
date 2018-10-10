FROM php:7.2

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
    gnupg \
    python-pydot \
    python-pydot-ng \
    graphviz

# Install phpdoc and deps
RUN wget http://phpdoc.org/phpDocumentor.phar
RUN mv phpDocumentor.phar /usr/local/bin/phpdoc
RUN chmod +x /usr/local/bin/phpdoc

# Install supervisor
RUN apt-get install -y supervisor

RUN update-ca-certificates

RUN docker-php-ext-install -j$(nproc) zip iconv opcache pdo pdo_mysql mbstring intl json gd bcmath pcntl \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Increase composer speed
RUN composer global require hirak/prestissimo

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime
RUN "date"

RUN echo 'alias sf="php bin/console"' >> ~/.bashrc

WORKDIR /var/www
