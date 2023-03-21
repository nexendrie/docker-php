FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# PHP
ENV PHP_MODS_DIR=/etc/php/8.2/mods-available
ENV PHP_CLI_DIR=/etc/php/8.2/cli/
ENV PHP_CLI_CONF_DIR=${PHP_CLI_DIR}/conf.d
ENV PHP_CGI_DIR=/etc/php/8.2/cgi/
ENV PHP_CGI_CONF_DIR=${PHP_CGI_DIR}/conf.d
ENV PHP_PHPDBG_DIR=/etc/php/8.2/phpdbg/
ENV PHP_PHPDBG_CONF_DIR=${PHP_PHPDBG_DIR}/conf.d
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
        php8.2-bcmath \
        php8.2-bz2 \
        php8.2-cgi \
        php8.2-cli \
        php8.2-ctype \
        php8.2-curl \
        php8.2-gd \
        php8.2-intl \
        php8.2-mbstring \
        php8.2-mysql \
        php8.2-sqlite3 \
        php8.2-ssh2 \
        php8.2-zip \
        php8.2-xml \
        php8.2-phpdbg \
        php8.2-pcov && \
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
