#!/usr/bin/env sh
set -e

echo "START CONFIGURING php-gd"

VERSION=`echo $PHP_VERSION | grep "^7\.4"`

apk add libgd zlib-dev \
    freetype freetype-dev \
    libpng libpng-dev \
    libjpeg-turbo libjpeg-turbo-dev \
    libwebp libwebp-dev

if [ ! -z  $VERSION ]
then
  docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp
else
  docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/freetype2 \
    --with-png-dir=/usr/include \
    --with-jpeg-dir=/usr/include \
    --with-webp-dir=/usr/include
fi

docker-php-ext-install gd

apk del zlib-dev freetype-dev libpng-dev libjpeg-turbo-dev libwebp-dev



echo "END OF CONFIGURING php-gd"