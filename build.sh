#!/usr/bin/env bash
versions=(
'5.6'
'7.0'
'7.1'
'7.2'
'7.3'
'7.4'
)
IMAGE=$1
for version in ${versions[*]}
do
  echo "build for php-$version"
  docker build --build-arg PHP_VERSION=$version -t $IMAGE:$version-fpm-nginx-alpine -f ./.docker/Dockerfile .
  docker push $IMAGE:$version-fpm-nginx-alpine
done

for version in ${versions[*]}
do
  echo "build for php-$version"
  TAG=$version-bitrix-alpine
  docker build --build-arg PHP_VERSION=$version -t $IMAGE:$TAG -f ./.bitrix/Dockerfile .
  docker push $IMAGE:$TAG
done

docker tag $IMAGE:7.4-fpm-nginx-alpine $IMAGE:latest
docker push $IMAGE:latest