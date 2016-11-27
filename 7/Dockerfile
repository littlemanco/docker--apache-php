FROM debian:stretch-slim

RUN export TIDYWAYS_VERSION="v4.0.7" && \
    export BUILD_PACKAGES="git libcurl4-openssl-dev libpcre3-dev build-essential gpg" && \
    export RUN_PACKAGES="apache2 libapache2-mod-php php-bcmath php-curl php-gd php-intl php-mbstring php-mcrypt php-pdo php-mysql php-simplexml php-soap php-xml php-xsl php-zip php-json php-iconv php-opcache php-dev" && \
    export TINI_VERSION="v0.13.0" && \
    # Install Requirements
    apt-get update && \
    apt-get install --yes \
        ${BUILD_PACKAGES} \
        ${RUN_PACKAGES} && \
    # Build steps
    git clone https://github.com/tideways/php-profiler-extension.git \
        --branch ${TIDYWAYS_VERSION} \
        /tmp/php-profiler-extension && \
    cd /tmp/php-profiler-extension && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    # Install tini init
    curl --location --output /sbin/tini  https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
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
    # Configure PHP
    ## Add tideways to the CLI
    echo "extension=tideways.so" >> /etc/php/7.0/cli/conf.d/99-profiler.ini && \
    echo "tideways.auto_prepend_library=0" >> /etc/php/7.0/cli/conf.d/99-profiler.ini && \
    ## Add tideways to Apache
    echo "extension=tideways.so" >> /etc/php/7.0/apache2/conf.d/99-profiler.ini && \
    echo "tideways.auto_prepend_library=0" >> /etc/php/7.0/apache2/conf.d/99-profiler.ini && \
    # Make apache log to stderr/stdout
    ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
