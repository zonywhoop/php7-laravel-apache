FROM php:7.0-apache

MAINTAINER Ed McLain <emclain@digitalmotion.tech>



RUN apt-get update && apt-get -y install         libfreetype6-dev         libjpeg62-turbo-dev         libmcrypt-dev         libpng12-dev         libxml2-dev         libcurl4-gnutls-dev         zlib1g-dev         git     && docker-php-ext-install -j2 bcmath mcrypt xml mbstring json curl zip pdo_mysql sockets pcntl     && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/     && docker-php-ext-install -j2 gd     && echo $(printf "\n" | pecl install redis)     && docker-php-ext-enable redis     && cd /usr/src/     && ln -s /etc/apache2/mods-available/rewrite.* /etc/apache2/mods-enabled/     && apt-get remove --purge -y libssl-dev libssl-doc     && rm -rf /var/lib/apt/lists/*     && curl -o /tmp/composer_setup https://getcomposer.org/installer     && php /tmp/composer_setup --install-dir=/usr/local/bin --filename=composer     && composer global require "laravel/installer"     && mkdir /var/www/laravel

COPY ./docker/apache-laravel.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80
