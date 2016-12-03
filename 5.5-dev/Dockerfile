# Todo: Change this for a git hash
FROM quay.io/littlemanco/apache-php:5.5-latest

RUN sudo apt-get update && \
    sudo apt-get install -y php5.5-xdebug

ADD 5.5-dev/etc/php/5.5/apache2/conf.d/30-xdebug.ini /etc/php/5.5/apache2/conf.d/30-xdebug.ini
ADD 5.5-dev/etc/php/5.5/apache2/conf.d/30-errors.ini /etc/php/5.5/apache2/conf.d/30-errors.ini
ADD 5.5-dev/etc/php/5.5/cli/conf.d/30-xdebug.ini     /etc/php/5.5/cli/conf.d/30-xdebug.ini
ADD 5.5-dev/etc/php/5.5/cli/conf.d/30-errors.ini     /etc/php/5.5/cli/conf.d/30-errors.ini
