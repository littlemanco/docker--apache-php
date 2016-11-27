FROM debian:stretch-slim

RUN export TIDYWAYS_VERSION="v4.0.7" && \
    export BUILD_PACKAGES="git libcurl4-openssl-dev libpcre3-dev build-essential gpg" && \
    export RUN_PACKAGES="apache2 libapache2-mod-php5 php5-bcmath php5-curl php5-gd php5-intl php5-mbstring php5-mcrypt php5-pdo php5-mysql php5-simplexml php5-soap php5-xml php5-xsl php5-zip php5-json php5-iconv php5-opcache php5-dev" && \
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
    echo "extension=tideways.so" >> /etc/php/5.6/cli/conf.d/99-profiler.ini && \
    echo "tideways.auto_prepend_library=0" >> /etc/php/5.6/cli/conf.d/99-profiler.ini && \
    ## Add tideways to Apache
    echo "extension=tideways.so" >> /etc/php/5.6/apache2/conf.d/99-profiler.ini && \
    echo "tideways.auto_prepend_library=0" >> /etc/php/5.6/apache2/conf.d/99-profiler.ini && \
    # Make apache log to stderr/stdout
    ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
