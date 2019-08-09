FROM dockette/debian:stretch

# PHP
ENV PHP_MODS_DIR=/etc/php/7.3/mods-available
ENV PHP_CLI_DIR=/etc/php/7.3/cli/
ENV PHP_CLI_CONF_DIR=${PHP_CLI_DIR}/conf.d
ENV PHP_CGI_DIR=/etc/php/7.3/cgi/
ENV PHP_CGI_CONF_DIR=${PHP_CGI_DIR}/conf.d
ENV PHP_PHPDBG_DIR=/etc/php/7.3/phpdbg/
ENV PHP_PHPDBG_CONF_DIR=${PHP_PHPDBG_DIR}/conf.d
ENV TZ=Europe/Prague
ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_ALLOW_SUPERUSER=1

# INSTALLATION
RUN apt update && apt full-upgrade -y && \
    # DEPENDENCIES #############################################################
    apt install -y wget curl apt-transport-https ca-certificates unzip && \
    # PHP DEB.SURY.CZ ##########################################################
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list && \
    apt update && \
    apt install -y --no-install-recommends \
        php-apcu \
        php-apcu-bc \
        php7.3-bcmath \
        php7.3-bz2 \
        php7.3-cgi \
        php7.3-cli \
        php7.3-ctype \
        php7.3-curl \
        php7.3-gd \
        php7.3-intl \
        php7.3-mbstring \
        php7.3-mysql \
        php7.3-pgsql \
        php7.3-sqlite3 \
        php-ssh2 \
        php7.3-zip \
        php-xdebug \
        php7.3-xml \
        php7.3-phpdbg \
        php7.3-pcov && \
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
ADD conf.d/custom.ini ${PHP_PHPDBG_CONF_DIR}/20-custom.ini

# COMMAND
CMD ["php"]
