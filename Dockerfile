FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# PHP
ENV PHP_MODS_DIR=/etc/php/7.4/mods-available
ENV PHP_CLI_DIR=/etc/php/7.4/cli/
ENV PHP_CLI_CONF_DIR=${PHP_CLI_DIR}/conf.d
ENV PHP_CGI_DIR=/etc/php/7.4/cgi/
ENV PHP_CGI_CONF_DIR=${PHP_CGI_DIR}/conf.d
ENV PHP_PHPDBG_DIR=/etc/php/7.4/phpdbg/
ENV PHP_PHPDBG_CONF_DIR=${PHP_PHPDBG_DIR}/conf.d
ENV TZ=Europe/Prague
ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_ALLOW_SUPERUSER=1

# INSTALLATION
RUN apt update && apt full-upgrade -y && \
    # DEPENDENCIES #############################################################
    apt install -y wget curl apt-transport-https ca-certificates unzip gnupg2 && \
    # GIT ######################################################################
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
    echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main" > /etc/apt/sources.list.d/git.list && \
    # PHP DEB.SURY.CZ ##########################################################
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu focal main" > /etc/apt/sources.list.d/php.list && \
    apt update && \
    apt install -y --no-install-recommends \
        git \
        php7.4-apcu \
        php7.4-apcu-bc \
        php7.4-bcmath \
        php7.4-bz2 \
        php7.4-cgi \
        php7.4-cli \
        php7.4-ctype \
        php7.4-curl \
        php7.4-gd \
        php7.4-intl \
        php7.4-mbstring \
        php7.4-mysql \
        php7.4-sqlite3 \
        php7.4-ssh2 \
        php7.4-zip \
        php7.4-xml \
        php7.4-phpdbg \
        php-pcov && \
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
