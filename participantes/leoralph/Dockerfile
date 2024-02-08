FROM dunglas/frankenphp

RUN echo "variables_order = \"EGPCS\"" >> $PHP_INI_DIR/conf.d/990-php.ini

RUN install-php-extensions pdo pdo_pgsql

WORKDIR /srv

COPY . /srv
COPY Caddyfile /etc/caddy/Caddyfile
