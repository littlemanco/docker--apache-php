FROM ubuntu:xenial-20161213

# VERSION is unused, it's just here to indicate which PHP version this build is expected to compile.
ENV VERSION=5.6.30-8

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
    export RUN_PACKAGES="apache2 libapache2-mod-php5.6 php5.6-curl php5.6-opcache php5.6-apcu php5.6-gd php5.6-intl php5.6-mbstring php5.6-mcrypt php5.6-pdo php5.6-mysql php5.6-simplexml php5.6-soap php5.6-xml php5.6-xsl php5.6-zip php5.6-json php5.6-iconv php5.6-opcache php5.6-dev tideways-php" && \
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
    # -- Enable SSL
    a2enmod ssl && \
    # -- Enable mod_status
    a2enmod status && \
    # -- Enable http2
    a2enmod http2 && \
    #
    # Configure PHP
    #
    for FILE in "/etc/php/5.6/cli/" "/etc/php/5.6/apache/"; do \
        # -- Tideways
        echo "tideways.auto_prepend_library=0" >> "${FILE}/conf.d/99-profiler.ini" && \
        # -- Opcache
        sed --in-place 's/;opcache.enable=0/opcache.enable=1/' "${FILE}/php.ini" && \
        sed --in-place 's/;opcache.enable_cli=0/opcache.enable_cli=1/' "${FILE}/php.ini" && \
        sed --in-place 's/;opcache.validate_timestamps=1/opcache.validate_timestamps=0/' "${FILE}/php.ini"; \
    done; \
    # -- In Xenial, PHP7 is the default runtime. Change it to php5.6
    update-alternatives --install /usr/bin/php php /usr/bin/php5.6 100 && \
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
