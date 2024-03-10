FROM php:8.3-cli

RUN pecl install swoole \
    && docker-php-ext-enable swoole

RUN apt-get update \
   # pgsql headers
    && apt-get install -y libpq-dev \
    && docker-php-ext-install pgsql pdo_pgsql pdo

WORKDIR "/app"

COPY . .

CMD php index.php
