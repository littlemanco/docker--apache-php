FROM debian:stretch-slim

RUN export CONTAINER_BUILD_PACKAGES="wget gpg" && \
    export BUILD_PACKAGES="apt-transport-https lsb-release ca-certificates software-properties-common curl" && \
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    apt-get install --yes ${BUILD_PACKAGES} ${CONTAINER_BUILD_PACKAGES} && \
    #
    # Add the PHP Repo from Ondrej
    # Instructions for adding this repo come from https://packages.sury.org/php/README.txt
    #
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    #
    # Add tidyways to the sources list
    #
    echo "deb http://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages debian main" >> /etc/apt/sources.list.d/tidyways.list && \
    curl https://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages/EEB5E8F4.gpg |  apt-key add - && \
    #
    # Install main packages
    #
    apt-get update && \
    export RUN_PACKAGES="apache2 libapache2-mod-php7.1 php7.1-curl php7.1-opcache php7.1-apcu php7.1-gd php7.1-intl php7.1-mbstring php7.1-mcrypt php7.1-pdo php7.1-mysql php7.1-simplexml php7.1-soap php7.1-xml php7.1-xsl php7.1-zip php7.1-json php7.1-iconv php7.1-opcache php7.1-dev tideways-php" && \
    apt-get update && \
    apt-get install --yes \
        ${RUN_PACKAGES} &&\
    #
    # Install tini init
    #
    export TINI_VERSION="v0.14.0" && \
    curl --location --output /sbin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    curl --location --output /tmp/tini.asc https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && \
    gpg --verify /tmp/tini.asc /sbin/tini && \
    chmod +x /sbin/tini && \
    # Clean up
    apt-get purge \
        --auto-remove \
        --yes \
        ${BUILD_PACKAGES} && \
    apt-get clean && \
    #
    # Configure apache
    #
    # -- Enable mod rewrite
    a2enmod rewrite && \
    # -- Enable SSL
    a2enmod ssl && \
    # -- Enable mod status
    a2enmod status && \
    # -- Enable HTTP/2
    a2enmod http2 && \
    #
    # Configure PHP
    #
    for FILE in "/etc/php/7.1/cli/" "/etc/php/7.1/apache2/"; do \
        # -- Tideways
        echo "tideways.auto_prepend_library=0" >> "${FILE}/conf.d/99-profiler.ini" && \
        # -- Opcache
        sed --in-place 's/;opcache.enable=0/opcache.enable=1/' "${FILE}/php.ini" && \
        sed --in-place 's/;opcache.enable_cli=0/opcache.enable_cli=1/' "${FILE}/php.ini" && \
        sed --in-place 's/;opcache.validate_timestamps=1/opcache.validate_timestamps=0/' "${FILE}/php.ini"; \
    done; \
    #
    # Logs
    #
    # -- Symlink the apache logs so they're piped to stdout
    ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
    #
    # Build cleanup
    #
    apt-get purge --yes ${CONTAINER_BUILD_PACKAGES}

# These should be overridden by your runtime environment
ENV SERVER_NAME www.example.com
ENV SERVER_ADMIN webmaster@localhost
ENV DOCUMENT_ROOT /var/www/html

# Update the default vhost to one that listens for the environment variables.
ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
