FROM debian:stretch-slim

RUN export TIDYWAYS_VERSION="v4.0.7" && \
    export BUILD_PACKAGES="git libcurl4-openssl-dev libpcre3-dev build-essential" && \
    export RUN_PACKAGES="apache2" && \
    apt-get update && \
    apt-get install -y ${BUILD_PACKAGES} ${RUN_PACKAGES} && \
    # Build steps
    git clone git clone https://github.com/tideways/php-profiler-extension.git --branch ${TIDYWAYS_VERSION} /tmp/php-profiler-extension && \
        cd /tmp/php-profiler-extensions && \
        phpize && \
        ./configure && \
        make && \
        make install && \
        apt-cache search php && \
    apt-get purge -y ${BUILD_PACKAGES} && \
    apt-get clean 
