ARG PHP_VERSION
FROM php:$PHP_VERSION-fpm-alpine

COPY .docker/ .docker/

RUN chmod +x .docker/build-php-gd.sh && .docker/build-php-gd.sh

RUN apk add nginx

RUN apk add libzip libzip-dev libxml2 libxml2-dev postgresql postgresql-dev
RUN docker-php-ext-install bcmath zip mysqli pdo_mysql pgsql pdo_pgsql
RUN apk del libzip-dev libxml2-dev postgresql-dev

RUN apk add autoconf g++ make
RUN pecl install redis
RUN docker-php-ext-enable redis
RUN apk del make g++ autoconf

RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    curl -s https://getcomposer.org/installer | php &&\
    mv composer.phar /usr/local/bin/composer && \
    curl -ssL https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 > /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu && \
    rm -vrf /var/cache/apk/* &&\
    chmod +x .docker/entrypoint.sh && \
    mv .docker/entrypoint.sh /usr/local/bin/entrypoint && \
    mkdir -p /var/tmp/nginx && chmod -R 777 /var/tmp/nginx && \
    mkdir -p /var/lib/nginx/tmp && chown -R www-data:www-data /var/lib/nginx/tmp && \
    chown www-data:www-data /var/lib/nginx && \
    rm -rf /usr/local/etc/php-fpm.d && \
    mv .docker/php/php-fpm.d /usr/local/etc/php-fpm.d && \
    mv -f .docker/php/php-fpm.conf /usr/local/etc/php-fpm.conf && \
    rm -rf /etc/nginx/conf.d && \
    cp -rf .docker/nginx /etc && \
    rm -rf .docker

WORKDIR /home/www-data
RUN chown -R www-data:www-data ./

USER root

ENV CONTAINER_ROLE app
ENV APP_ENV production
ENV QUEUE_TRIES 3
ENV QUEUE_TIMEOUT 180
ENV QUEUE_SLEEP_SECONDS 3
ENV QUEUE_DELAY 0
ENV SV_NUM_PROCS 4
ENV QUEUE_MEMORY 128

ENTRYPOINT [ "entrypoint" ]
