FROM ubuntu:xenial-20161213

# Build packages 
RUN export BUILD_PACKAGES="build-essential apache2-dev libxml2-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libxpm-dev libmysqlclient-dev libpq-dev libicu-dev libfreetype6-dev libldap2-dev libxslt-dev git" && \
    export RUN_PACKAGES="apache2" && \
    export PHP_VERSION="5.6.29" && \
    apt-get update && \
    apt-get install ${BUILD_PACKAGES} ${RUN_PACKAGES} -y && \
    git clone https://github.com:php/php-src.git /tmp/php-src.git && \
    cd /tmp/php-src.git && \
    git checkout ${PHP_VERSION} && \
    ./configure --help && \
    apt-get purge ${BUILD_PACKAGES}

