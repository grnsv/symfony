FROM php:8.1-fpm

ARG UID=1000
ARG GID=1000
ENV USER=www-data

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions \
    @composer \
    amqp \
    ctype \
    curl \
    gd \
    iconv \
    intl \
    opcache \
    openssl \
    pdo_pgsql \
    redis \
    sodium \
    xdebug \
    xsl \
    zip

RUN curl -sS https://get.symfony.com/cli/installer | bash -s -- --install-dir=/usr/local/bin

RUN usermod -o -u $UID $USER && groupmod -o -g $GID $USER
RUN chown -R $UID:$GID /var/www

USER $USER
