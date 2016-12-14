FROM ubuntu:xenial-20161121

RUN export BUILD_PACKAGES="software-properties-common language-pack-en-base curl" && \ 
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    apt-get update && \
    apt-get install -y ${BUILD_PACKAGES} && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update

RUN echo "deb http://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages debian main" >> /etc/apt/sources.list.d/tidyways.list
RUN curl https://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages/EEB5E8F4.gpg |  apt-key add -
RUN apt-get update
RUN export RUN_PACKAGES="apache2 libapache2-mod-php7.1 php7.1-apcu php7.1-curl php7.1-gd php7.1-intl php7.1-mbstring php7.1-mcrypt php7.1-pdo php7.1-mysql php7.1-simplexml php7.1-soap php7.1-xml php7.1-xsl php7.1-zip php7.1-json php7.1-iconv php7.1-opcache php7.1-dev tideways-php" && \
    apt-get update && \
    apt-get install --yes \
        ${BUILD_PACKAGES} \
        ${RUN_PACKAGES}
    # Install tini init

RUN export TINI_VERSION="v0.13.0" && \
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
    apt-get clean

# Configure apache
RUN a2enmod rewrite

# Configure PHP
    ## Add tideways to the CLI
RUN echo "extension=tideways.so" >> /etc/php/7.1/cli/conf.d/99-profiler.ini && \
    echo "tideways.auto_prepend_library=0" >> /etc/php/7.1/cli/conf.d/99-profiler.ini && \
    ## Add tideways to Apache
    echo "extension=tideways.so" >> /etc/php/7.1/apache2/conf.d/99-profiler.ini && \
    echo "tideways.auto_prepend_library=0" >> /etc/php/7.1/apache2/conf.d/99-profiler.ini

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
