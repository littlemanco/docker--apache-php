#!/bin/bash
#
# Provisioner script. Expects environment variables PHP_VERSION and TINI_VERSION to be defined in the Dockerfile
# An example is below:
#
#  ENV PHP_VERSION "5.6"
#  ENV TINI_VERSION "16.1" # Optional
#

TINI_VERSION=${TINI_VERSION:-v0.17.0}

# Exit codes from sysexists.h
__EXIT_CODE_USAGE=64
__EXIT_OSERR=71

__exit() {
  __EXIT_MESSAGE="$1"
  __EXIT_CODE=$2

  >&2 echo "$__EXIT_MESSAGE"
  exit $__EXIT_CODE
}

__check_env() {
  # Checks that the expected environment variables are defined  
  if [[ -z "$PHP_VERSION" ]] || [[ -z "$TINI_VERSION" ]]; then
      __exit "Expected environment variables PHP_VERSION and TINI_VERSION. Not found" $__EXIT_CODE_USAGE
  fi
}

__provision() {
    export CONTAINER_BUILD_PACKAGES="wget gpg" && \
    export BUILD_PACKAGES="lsb-release software-properties-common" && \
    export RUN_PACKAGES="apt-transport-https ca-certificates curl" && \
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    #
    # Do base filesystem upgrades to update anything between when the original FS was released and build time
    #
    apt-get update && \
    apt-get dist-upgrade --yes && \
    #
    # Install required packages
    #
    apt-get install --yes ${BUILD_PACKAGES} ${CONTAINER_BUILD_PACKAGES} ${RUN_PACKAGES} && \
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
    export RUN_PACKAGES="apache2 libapache2-mod-php${PHP_VERSION} php${PHP_VERSION}-curl php${PHP_VERSION}-opcache php${PHP_VERSION}-apcu php${PHP_VERSION}-gd php${PHP_VERSION}-intl php${PHP_VERSION}-mbstring php${PHP_VERSION}-mcrypt php${PHP_VERSION}-pdo php${PHP_VERSION}-mysql php${PHP_VERSION}-simplexml php${PHP_VERSION}-soap php${PHP_VERSION}-xml php${PHP_VERSION}-xsl php${PHP_VERSION}-zip php${PHP_VERSION}-json php${PHP_VERSION}-iconv php${PHP_VERSION}-opcache php${PHP_VERSION}-dev tideways-php" && \
    apt-get update && \
    apt-get install --yes \
        ${RUN_PACKAGES} &&\
    #
    # Install tini init
    #
    curl --location --output /sbin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
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
    # -- Enable HTTP/2
    a2enmod http2 && \
    # -- Enable mod_header
    a2enmod headers && \
    #
    # Configure PHP
    #
    for FILE in "/etc/php/${PHP_VERSION}/cli/" "/etc/php/${PHP_VERSION}/apache2/"; do \
        # -- Tideways
        echo "tideways.auto_prepend_library=0" >> "${FILE}/conf.d/99-profiler.ini" && \
        # -- Opcache
        sed --in-place 's/;opcache.enable=0/opcache.enable=1/' "${FILE}/php.ini" && \
        sed --in-place 's/;opcache.enable_cli=0/opcache.enable_cli=1/' "${FILE}/php.ini" && \
        sed --in-place 's/;opcache.validate_timestamps=1/opcache.validate_timestamps=0/' "${FILE}/php.ini" && \
        # -- Memory
        sed --in-place 's/128M/512M/' "${FILE}/php.ini"; \
    done; \
    # -- In Xenial, PHP7 is the default runtime. Change it to php${PHP_VERSION}
    update-alternatives --install /usr/bin/php php /usr/bin/php${PHP_VERSION} 100 && \
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
}

main() {
  __check_env;
  __provision;
}

main $@
