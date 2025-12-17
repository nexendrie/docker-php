FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

# PHP
ENV PHP_MODS_DIR=/etc/php/8.5/mods-available
ENV PHP_CLI_DIR=/etc/php/8.5/cli/
ENV PHP_CLI_CONF_DIR=${PHP_CLI_DIR}/conf.d
ENV PHP_CGI_DIR=/etc/php/8.5/cgi/
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
        memcached \
        php8.5-apcu \
        php8.5-bcmath \
        php8.5-bz2 \
        php8.5-cgi \
        php8.5-cli \
        php8.5-ctype \
        php8.5-curl \
        php8.5-gd \
        php8.5-intl \
        php8.5-mbstring \
        php8.5-mysql \
        php8.5-sqlite3 \
        php8.5-ssh2 \
        php8.5-zip \
        php8.5-xml \
        php8.5-pcov \
        php8.5-memcached \
        php8.5-redis && \
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
