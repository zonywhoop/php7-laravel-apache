FROM php:7.2-apache-stretch

MAINTAINER Ed McLain <emclain@digitalmotion.tech>

WORKDIR /var/www/laravel



RUN apt-get update     && apt-get -y upgrade     && apt-get -y install --no-install-recommends         libfreetype6-dev         libjpeg62-turbo-dev         libmcrypt-dev         libpng-dev         libxml2-dev         libcurl4-gnutls-dev         zlib1g-dev         git         unzip     && docker-php-ext-install -j2 bcmath xml zip pdo_mysql mysqli sockets pcntl     && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/     && docker-php-ext-install -j2 gd     && echo $(printf "\n" | pecl install redis)     && docker-php-ext-enable redis     && cd /usr/src/     && ln -s /etc/apache2/mods-available/rewrite.* /etc/apache2/mods-enabled/     && curl -o /tmp/composer_setup https://getcomposer.org/installer     && php /tmp/composer_setup --install-dir=/usr/local/bin --filename=composer     && composer global require "laravel/installer"     && apt-get remove --purge -y libssl-dev libssl-doc     && rm -rf /var/lib/apt/lists/*     && apt-get clean autoclean     && apt-get autoremove -y     && rm -rf /var/lib/apt/lists/* /tmp/* /var/lib/dpkg/* /var/lib/cache/* /var/lib/log/*

COPY docker/apache-laravel.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80
