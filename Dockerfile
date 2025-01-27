#syntax=docker/dockerfile:1.7

# Adapted from https://github.com/dunglas/symfony-docker


# Versions
FROM dunglas/frankenphp:1-php8.4 AS frankenphp_upstream


# The different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target


# Base FrankenPHP image
FROM frankenphp_upstream AS frankenphp_base

WORKDIR /app

# persistent / runtime deps
# hadolint ignore=DL3008
RUN apt-get update && apt-get install --no-install-recommends -y \
  acl \
  file \
  gettext \
  git \
  && rm -rf /var/lib/apt/lists/*

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN set -eux; \
  install-php-extensions \
  @composer \
  intl \
  apcu \
  opcache \
  zip \
  ;

###> recipes ###
###> doctrine/doctrine-bundle ###
RUN set -eux; \
  install-php-extensions pdo_pgsql