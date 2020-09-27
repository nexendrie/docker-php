FROM php:8.0-rc

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV PHP_CLI_CONF_DIR=${PHP_INI_DIR}
ENV TZ=Europe/Prague
ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_ALLOW_SUPERUSER=1

# INSTALLATION
RUN apt update && apt full-upgrade -y && \
    # DEPENDENCIES #############################################################
    apt install -y wget curl apt-transport-https ca-certificates unzip gnupg2 git libonig-dev \
    libcurl4-openssl-dev libbz2-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev libicu-dev && \
    docker-php-ext-install bcmath bz2 zip mysqli pdo pdo_mysql && \
    docker-php-ext-enable pdo_mysql && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install -j$(nproc) intl && \
    #mkdir -p /usr/src/php/ext/apcu && curl -fsSl https://pecl.php.net/get/apcu | tar xvz -C "/usr/src/php/ext/apcu" --strip 1 && \
    #docker-php-ext-install apcu && \
    #mkdir -p /usr/src/php/ext/apcu_bc && curl -fsSl https://pecl.php.net/get/apcu_bc | tar xvz -C "/usr/src/php/ext/apcu_bc" --strip 1 && \
    #docker-php-ext-install apcu_bc && \
    mkdir -p /usr/src/php/ext/pcov && curl -fsSl https://pecl.php.net/get/pcov | tar xvz -C "/usr/src/php/ext/pcov" --strip 1 && \
    docker-php-ext-install pcov && \
    # COMPOSER #################################################################
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    # PHING ####################################################################
    curl -sS https://www.phing.info/get/phing-latest.phar > /usr/local/bin/phing && chmod +x /usr/local/bin/phing && \
    # CLEAN UP #################################################################
    apt clean -y && \
    apt autoclean -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

# FILES (it overrides originals)
ADD conf.d/custom.ini ${PHP_CLI_CONF_DIR}/20-custom.ini

# COMMAND
CMD ["php"]
