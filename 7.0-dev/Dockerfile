# Todo: Change this for a git hash
FROM quay.io/littlemanco/apache-php:7.0-latest

RUN sudo apt-get update && \
    sudo apt-get install -y \
        php7.0-xdebug \
        strace \
        tcpdump \
        dnsutils

ADD 7.0-dev/etc/php/7.0/apache2/conf.d/30-xdebug.ini /etc/php/7.0/apache2/conf.d/30-xdebug.ini
ADD 7.0-dev/etc/php/7.0/apache2/conf.d/30-errors.ini /etc/php/7.0/apache2/conf.d/30-errors.ini
ADD 7.0-dev/etc/php/7.0/cli/conf.d/30-xdebug.ini     /etc/php/7.0/cli/conf.d/30-xdebug.ini
ADD 7.0-dev/etc/php/7.0/cli/conf.d/30-errors.ini     /etc/php/7.0/cli/conf.d/30-errors.ini
