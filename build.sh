#!/usr/bin/env bash
versions=(
'5.6'
'7.0'
'7.1'
'7.2'
'7.3'
)
IMAGE=$1
for version in ${versions[*]}
do
  echo "build for php-$version"
  docker build --build-arg PHP_VERSION=$version -t $IMAGE:$version-fpm-nginx-alpine .
  docker push $IMAGE:$version-fpm-nginx-alpine
done

docker tag $IMAGE:7.3-fpm-nginx-alpine $IMAGE:latest
docker push $IMAGE:latest