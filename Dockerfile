FROM php:7.0-apache
RUN apt-get update && apt-get -y install \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        libcurl4-gnutls-dev \
        zlib1g-dev \
        git \
    && docker-php-ext-install -j$(nproc) bcmath mcrypt xml mbstring json curl zip pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && ln -s /etc/apache2/mods-available/rewrite.* /etc/apache2/mods-enabled/ \
    && curl -o /tmp/composer_setup https://getcomposer.org/installer \
    && php /tmp/composer_setup --install-dir=/usr/local/bin --filename=composer \
    && composer global require "laravel/installer" \
    && mkdir /var/www/laravel
    
RUN mv /var/www/html /var/www/html.old \
    && ln -s /var/www/laravel/public /var/www/html
    
