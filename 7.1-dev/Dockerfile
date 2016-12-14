# Todo: Change this for a git hash
FROM quay.io/littlemanco/apache-php:7.1-latest

RUN apt-get update && \
    apt-get install -y \
        php7.1-xdebug \
        strace \
        tcpdump \
        dnsutils

ADD 7.1-dev/etc/php/7.1/apache2/conf.d/30-xdebug.ini /etc/php/7.1/apache2/conf.d/30-xdebug.ini
ADD 7.1-dev/etc/php/7.1/apache2/conf.d/30-errors.ini /etc/php/7.1/apache2/conf.d/30-errors.ini
ADD 7.1-dev/etc/php/7.1/cli/conf.d/30-xdebug.ini     /etc/php/7.1/cli/conf.d/30-xdebug.ini
ADD 7.1-dev/etc/php/7.1/cli/conf.d/30-errors.ini     /etc/php/7.1/cli/conf.d/30-errors.ini
