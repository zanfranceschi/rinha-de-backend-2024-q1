# Use a imagem base do PHP 8.3
FROM php:8.3-fpm

RUN apt-get update && \
    apt-get install -y libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pgsql

WORKDIR /var/www/

RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN rm /usr/local/etc/php/php.ini-development

# Define variáveis de ambiente
ENV PHP_HOME=/usr/local/8.3-fpm
ENV PATH=$PHP_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG=C.UTF-8
ENV PHP_VERSION=8.3

# Comando padrão a ser executado quando o contêiner for iniciado
CMD ["php", "-S", "0.0.0.0:8080"]
