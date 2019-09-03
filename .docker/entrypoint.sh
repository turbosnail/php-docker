#!/usr/bin/env sh

set -e

role=${CONTAINER_ROLE:-app}
env=${APP_ENV:-production}
queueTries=${QUEUE_TRIES:-3}
queueTimeout=${QUEUE_TIMEOUT:-90}
queueSleepSeconds=${QUEUE_SLEEP_SECONDS:-3}

# Runs application with nginx and FPM and makes some preparations for laravel application
# folders structure, permissions, etc.
run_application() {
  echo Give permissions to www-data to mounted volume directories
  chown -R www-data: /home/www-data/public /home/www-data/storage
  echo "Check nginx is fine"
  nginx -t
  echo "Run artisan migrations"
  php artisan migrate --force
  echo "Link artisan storage event if it's been already linked and suppress all errors"
  php artisan storage:link 2>/dev/null
  echo "Run FPM"
  php-fpm
  echo "Run NGINX as root process"
  nginx
}

if [[ "$env" != "local" ]]; then
  echo "Cache application configuration..."
  # Caching everything for laravel in non-production mode
#  (php artisan config:cache && php artisan view:cache)
fi

if [[ "$role" == "app" ]]; then
  echo "Bootstraping application..."
  # If running app container we'll run nginx and all that stuff
  run_application

elif [[ "$role" == "scheduler" ]]; then

  echo "Running scheduler..."
  # If running scheduler container we'll run infinite loop with 60 seconds timeout
  # and artisan schedule command each minute
  while :
  do
    gosu www-data php artisan schedule:run --verbose --no-interaction &
    sleep 60
  done

elif [[ "$role" == "queue" ]]; then

  echo "Running queue..."
  # If running queue container, we'll just run artisan queue:work command with settings
  gosu www-data php artisan queue:work \
    --verbose \
    --tries "$queueTries" \
    --timeout "$queueTimeout" \
    --sleep "$queueSleepSeconds"

else
  echo "No matched action for given container role [$role]"
  exit 1
fi
