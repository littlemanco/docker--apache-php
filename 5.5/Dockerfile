FROM ubuntu:trusty-20161123

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
RUN export RUN_PACKAGES="apache2 libapache2-mod-php5.5 php5.5-curl php5.5-gd php5.5-intl php5.5-mbstring php5.5-mcrypt php5.5-pdo php5.5-mysql php5.5-simplexml php5.5-soap php5.5-xml php5.5-xsl php5.5-zip php5.5-json php5.5-iconv php5.5-opcache php5.5-dev tideways-php" && \
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
RUN echo "extension=tideways.so" >> /etc/php/5.5/cli/conf.d/99-profiler.ini && \
    echo "tideways.auto_prepend_library=0" >> /etc/php/5.5/cli/conf.d/99-profiler.ini && \
    ## Add tideways to Apache
    echo "extension=tideways.so" >> /etc/php/5.5/apache2/conf.d/99-profiler.ini && \
    echo "tideways.auto_prepend_library=0" >> /etc/php/5.5/apache2/conf.d/99-profiler.ini

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
