FROM php:7.2-fpm-alpine

RUN apk add \
    freetype freetype-dev \
    libpng libpng-dev \
    libjpeg-turbo libjpeg-turbo-dev \
    libzip libzip-dev \
    libxml2 libxml2-dev \
    nginx && \
    docker-php-ext-configure gd \
            --with-freetype-dir=/usr/include/freetype2 \
            --with-png-dir=/usr/include \
            --with-jpeg-dir=/usr/include && \
    /usr/local/bin/docker-php-ext-install bcmath gd zip soap mysqli pdo_mysql && \
    apk del freetype-dev libpng-dev libjpeg-turbo-dev libzip-dev libxml2-dev postgresql-dev && \
    mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    curl -s https://getcomposer.org/installer | php &&\
    mv composer.phar /usr/local/bin/composer && \
    curl -ssL https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 > /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu && \
    rm -vrf /var/cache/apk/*

COPY . .

RUN chmod +x .docker/entrypoint.sh && \
    mv .docker/entrypoint.sh /usr/local/bin/entrypoint && \
    chmod -R 777 /var/tmp/nginx && \
    rm -rf /usr/local/etc/php-fpm.d && \
    mv .docker/php/php-fpm.d /usr/local/etc/php-fpm.d && \
    mv -f .docker/php/php-fpm.conf /usr/local/etc/php-fpm.conf && \
    cp -rf .docker/nginx /etc && \
    rm -rf .docker

WORKDIR /home/www-data
RUN chown -R www-data:www-data ./

USER root
ENTRYPOINT [ "entrypoint" ]
