FROM quay.io/littlemanco/apache-php:7.0-rc3

RUN apt-get update && \
    # Install development packages
    apt-get install -y \
        php7.0-xdebug \
        strace \
        tcpdump \
        dnsutils && \
    # Configure PHP
    #
    # -- Customize PHP configuration
    for FILE in "/etc/php/7.0/cli/" "/etc/php/7.0/apache2/"; do \
        # -- Opcache
        sed --in-place 's/opcache.validate_timestamps=0/;opcache.validate_timestamps=1/' "${FILE}/php.ini"; \
        sed --in-place 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=0/' "${FILE}/php.ini"; \
    done;

ADD etc/php/7.0/apache2/conf.d/30-xdebug.ini /etc/php/7.0/apache2/conf.d/30-xdebug.ini
ADD etc/php/7.0/apache2/conf.d/30-errors.ini /etc/php/7.0/apache2/conf.d/30-errors.ini
ADD etc/php/7.0/cli/conf.d/30-xdebug.ini     /etc/php/7.0/cli/conf.d/30-xdebug.ini
ADD etc/php/7.0/cli/conf.d/30-errors.ini     /etc/php/7.0/cli/conf.d/30-errors.ini
