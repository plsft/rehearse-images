FROM php:8.3-cli

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC

RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make unzip libzip-dev libpq-dev libonig-dev \
      default-libmysqlclient-dev libicu-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql zip intl bcmath \
    && rm -rf /var/lib/apt/lists/*

# Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Warm Composer cache with common deps.
RUN mkdir -p /tmp/warm-php && cd /tmp/warm-php && composer init -n --name warm/warm >/dev/null && \
    composer require --dev phpunit/phpunit symfony/console laravel/framework guzzlehttp/guzzle monolog/monolog 2>/dev/null || true && \
    cd / && rm -rf /tmp/warm-php

COPY shared/runner-user.sh /tmp/runner-user.sh
RUN chmod +x /tmp/runner-user.sh && /tmp/runner-user.sh && rm /tmp/runner-user.sh

WORKDIR /workspace
USER runner

COPY php/8.3/smoke.sh /smoke.sh
LABEL org.opencontainers.image.source="https://github.com/rehearse-sh/images" \
      org.opencontainers.image.title="rehearse-pro/php:8.3-warm" \
      org.opencontainers.image.description="PHP 8.3 + Composer with warmed cache."
