FROM wordpress:php8.3-fpm-alpine

# Set system-wide locale settings
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Update alpine
RUN apk update \
    && apk upgrade

# Install bash
RUN apk add bash

# Setup shell
COPY scripts/shell.sh /shell.sh
RUN /bin/bash /shell.sh --alpine

# PHP Redis
RUN apk add --no-cache pcre-dev $PHPIZE_DEPS \
    && echo 'no' | pecl install redis \
    && docker-php-ext-enable redis.so