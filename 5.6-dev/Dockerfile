# Todo: Change this for a git hash
FROM quay.io/littlemanco/apache-php:5.6-rc3

RUN apt-get update && \
    apt-get install -y \
        php5.6-xdebug \
        strace \
        tcpdump \
        dnsutils

ADD 5.6-dev/etc/php/5.6/apache2/conf.d/30-xdebug.ini /etc/php/5.6/apache2/conf.d/30-xdebug.ini
ADD 5.6-dev/etc/php/5.6/apache2/conf.d/30-errors.ini /etc/php/5.6/apache2/conf.d/30-errors.ini
ADD 5.6-dev/etc/php/5.6/cli/conf.d/30-xdebug.ini     /etc/php/5.6/cli/conf.d/30-xdebug.ini
ADD 5.6-dev/etc/php/5.6/cli/conf.d/30-errors.ini     /etc/php/5.6/cli/conf.d/30-errors.ini
