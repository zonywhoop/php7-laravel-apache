#!/bin/bash
PHPFROM=(7.1 7.2 7.4)

for phpver in ${PHPFROM[*]}; do 
    echo "Building Dockerfile for PHP ${phpver}"

    gdBuild="docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/"

    if [ "$phpver" == "7.1" ]; then
      dockerFrom="php:${phpver}-apache-stretch"
      phpmods="bcmath mcrypt xml zip pdo_mysql mysqli sockets pcntl"
    else
      dockerFrom="php:${phpver}-apache-buster"
      phpmods="bcmath xml zip pdo_mysql mysqli sockets pcntl"
      if [ "$phpver" != "7.2" ]; then
        gdBuild="docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/"
      fi
    fi

    dockerAdd=""

    if [ ! -d "${phpver}" ]; then
      mkdir ${phpver}
    fi
    cat > ${phpver}/Dockerfile << EOF
FROM ${dockerFrom}

MAINTAINER Ed McLain <emclain@digitalmotion.tech>

WORKDIR /var/www/laravel

${dockerAdd}

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        libcurl4-gnutls-dev \
        zlib1g-dev \
        libzip-dev \
        git \
        unzip \
    && docker-php-ext-install -j2 $phpmods \
    && ${gdBuild} \
    && docker-php-ext-install -j2 gd \
    && echo \$(printf "\n" | pecl install redis) \
    && docker-php-ext-enable redis \
    && cd /usr/src/ \
    && ln -s /etc/apache2/mods-available/rewrite.* /etc/apache2/mods-enabled/ \
    && curl -o /tmp/composer_setup https://getcomposer.org/installer \
    && php /tmp/composer_setup --install-dir=/usr/local/bin --filename=composer \
    && composer global require "laravel/installer" \
    && apt-get remove --purge -y libssl-dev libssl-doc \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/lib/dpkg/* /var/lib/cache/* /var/lib/log/*

COPY docker/apache-laravel.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80
EOF
  cp ${phpver}/Dockerfile ./
done
