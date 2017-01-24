FROM quay.io/littlemanco/apache-php:5.6-rc5

# This presumes that the user will start mailhog in the container
ENV SMTP_ADDR="localhost:1025"

RUN apt-get update && \
    # Install development packages
    apt-get install -y \
        php5.6-xdebug \
        strace \
        tcpdump \
        dnsutils && \
    #
    # Mailhog
    #
    # -- Install
    curl -O "https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64" && \
    mv "mhsendmail_linux_amd64" "/usr/local/bin/mhsendmail" && \
    #
    # Configure PHP
    #
    # -- Customize PHP configuration
    for FILE in "/etc/php/5.6/cli/" "/etc/php/5.6/apache/"; do \
        # -- Opcache
        sed --in-plcae 's:;sendmail_path =:sendmail_path = /usr/local/bin/mhsendmail --smtp-addr="${SMTP_ADDR}:"' && \
        sed --in-place 's/opcache.validate_timestamps=0/;opcache.validate_timestamps=1/' "${FILE}/php.ini" &&  \
        sed --in-place 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=0/' "${FILE}/php.ini" && \
    done;

ADD etc/php/5.6/apache2/conf.d/30-xdebug.ini /etc/php/5.6/apache2/conf.d/30-xdebug.ini
ADD etc/php/5.6/apache2/conf.d/30-errors.ini /etc/php/5.6/apache2/conf.d/30-errors.ini
ADD etc/php/5.6/cli/conf.d/30-xdebug.ini     /etc/php/5.6/cli/conf.d/30-xdebug.ini
ADD etc/php/5.6/cli/conf.d/30-errors.ini     /etc/php/5.6/cli/conf.d/30-errors.ini
