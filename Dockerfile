FROM php:8.1-fpm

ARG UID=1000
ARG GID=1000
ENV USER=www-data

RUN apt-get update && apt-get install -y \
    postgresql-client

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions amqp
RUN install-php-extensions ctype
RUN install-php-extensions curl
RUN install-php-extensions gd
RUN install-php-extensions iconv
RUN install-php-extensions intl
RUN install-php-extensions opcache
RUN install-php-extensions openssl
RUN install-php-extensions pdo_pgsql
RUN install-php-extensions redis
RUN install-php-extensions sodium
RUN install-php-extensions xdebug
RUN install-php-extensions xsl
RUN install-php-extensions zip
RUN install-php-extensions @composer

RUN curl -sS https://get.symfony.com/cli/installer | bash -s -- --install-dir=/usr/local/bin

RUN usermod -o -u $UID $USER && groupmod -o -g $GID $USER
RUN chown -R $UID:$GID /var/www

USER $USER

ENTRYPOINT [ "symfony", "run", "-d", "--watch=config,src,templates,vendor", "symfony", "console", "messenger:consume", "async", "-vv"]
