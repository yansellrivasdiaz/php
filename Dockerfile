FROM php:7.4.6-fpm-alpine

LABEL maintainer='Yansell Rivas <yansellrivasdiaz@gmail.com>'

# Install dependencies
RUN apk update \
    && apk add --no-cache $PHPIZE_DEPS ncurses g++ zip libzip-dev zip icu-dev make oniguruma-dev libxml2-dev libmcrypt-dev freetype-dev libpng-dev libjpeg-turbo-dev jpeg-dev wkhtmltopdf xvfb \
    && docker-php-ext-install bcmath iconv mbstring xml xmlrpc xmlwriter opcache pdo pdo_mysql exif \
    && pecl install mcrypt-1.0.3 \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure zip \
    && docker-php-ext-install -j$(nproc) gd intl zip \
    && rm -rf /var/cache/apk/*

COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./php.custom.ini /usr/local/etc/php/conf.d/php.custom.ini

CMD [ "php-fpm", "-R" ]
