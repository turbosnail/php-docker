#!/usr/bin/env sh

set -e

# Runs application with nginx and FPM and makes some preparations for laravel application
# folders structure, permissions, etc.

echo "Check nginx is fine"
nginx -t
echo "Run FPM"
php-fpm
echo "Run NGINX as root process"
nginx
