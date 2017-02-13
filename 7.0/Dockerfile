FROM ubuntu:xenial-20170119

RUN export BUILD_PACKAGES="software-properties-common language-pack-en-base curl" && \
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    apt-get update && \
    apt-get install -y ${BUILD_PACKAGES} && \
    add-apt-repository ppa:ondrej/php && \
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
    export RUN_PACKAGES="apache2 libapache2-mod-php7.0 php7.0-curl php7.0-opcache php7.0-apcu php7.0-gd php7.0-intl php7.0-mbstring php7.0-mcrypt php7.0-pdo php7.0-mysql php7.0-simplexml php7.0-soap php7.0-xml php7.0-xsl php7.0-zip php7.0-json php7.0-iconv php7.0-opcache php7.0-dev tideways-php" && \
    apt-get update && \
    apt-get install --yes \
        ${BUILD_PACKAGES} \
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
    #
    # Configure PHP
    #
    for FILE in "/etc/php/7.0/cli/" "/etc/php/7.0/apache2/"; do \
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
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

# These should be overridden by your runtime environment
ENV SERVER_NAME www.example.com
ENV SERVER_ADMIN webmaster@localhost
ENV DOCUMENT_ROOT /var/www/html

# Update the default vhost to one that listens for the environment variables.
ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
