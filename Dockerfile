FROM ubuntu:24.04

ARG PHP_VERSION=8.5
ARG GIT_COMMIT=local-dev
ARG BUILD_DATE=unknown
ARG BASE_DIGEST=unknown

LABEL org.opencontainers.image.title="Nexendrie PHP Image"
LABEL org.opencontainers.image.description="Nexendrie PHP docker image for continuous integration"
LABEL org.opencontainers.image.version="${PHP_VERSION}"
LABEL org.opencontainers.image.authors="Jakub Konečný <jakub.konecny2@centrum.cz>"
LABEL org.opencontainers.image.vendor="Nexendrie Project"
LABEL org.opencontainers.image.licenses="PHP-3.01 AND MIT AND LGPL-3.0-or-later"
LABEL org.opencontainers.image.url="https://nexendrie.gitlab.io/docker-php"
LABEL org.opencontainers.image.documentation="https://gitlab.com/nexendrie/docker-php"
LABEL org.opencontainers.image.source="https://gitlab.com/nexendrie/docker-php"
LABEL org.opencontainers.image.ref.name="master"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.base.name="docker.io/library/ubuntu:24.04"
LABEL org.opencontainers.image.base.digest="${BASE_DIGEST}"

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

# PHP
ENV PHP_MODS_DIR=/etc/php/${PHP_VERSION}/mods-available
ENV PHP_CLI_DIR=/etc/php/${PHP_VERSION}/cli/
ENV PHP_CLI_CONF_DIR=${PHP_CLI_DIR}/conf.d
ENV PHP_CGI_DIR=/etc/php/${PHP_VERSION}/cgi/
ENV PHP_CGI_CONF_DIR=${PHP_CGI_DIR}/conf.d
ENV TZ=Europe/Prague
ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_ALLOW_SUPERUSER=1

# INSTALLATION
RUN apt update && apt full-upgrade -y && \
    # DEPENDENCIES #############################################################
    apt install -y wget curl ca-certificates unzip gnupg2 software-properties-common && \
    # GIT ######################################################################
    add-apt-repository ppa:git-core/ppa && \
    # PHP DEB.SURY.CZ ########################################################## \
    add-apt-repository ppa:ondrej/php && \
    apt update && \
    apt install -y --no-install-recommends \
        git \
        patch \
        memcached \
        php${PHP_VERSION}-apcu \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-bz2 \
        php${PHP_VERSION}-cgi \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-ctype \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-sqlite3 \
        php${PHP_VERSION}-ssh2 \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-pcov \
        php${PHP_VERSION}-memcached \
        php${PHP_VERSION}-redis && \
    # COMPOSER #################################################################
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    # PHING ####################################################################
    curl -sS https://www.phing.info/get/phing-latest.phar > /usr/local/bin/phing && chmod +x /usr/local/bin/phing && \
    # PHP MOD(s) ###############################################################
    ln -s ${PHP_MODS_DIR}/custom.ini ${PHP_CLI_CONF_DIR}/999-custom.ini && \
    ln -s ${PHP_MODS_DIR}/custom.ini ${PHP_CGI_CONF_DIR}/999-custom.ini && \
    # CLEAN UP #################################################################
    apt clean -y && \
    apt autoclean -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

# FILES (it overrides originals)
ADD conf.d/custom.ini ${PHP_CLI_CONF_DIR}/20-custom.ini
ADD conf.d/custom.ini ${PHP_CGI_CONF_DIR}/20-custom.ini

# COMMAND
CMD ["php"]
