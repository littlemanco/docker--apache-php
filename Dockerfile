FROM debian:stretch-slim

ARG TINI_VERSION="v0.18.0"
ARG PHP_VERSION

##
## Set the path to the TLS certificate to use. Uses the "snake-oil" certificate by default.
##
## See
##   - https://askubuntu.com/questions/396120/what-is-the-purpose-of-the-ssl-cert-snakeoil-key
##
ENV SERVER_TLS_CERTIFICATE_PATH="/etc/ssl/certs/ssl-cert-snakeoil.pem"
ENV SERVER_TLS_CERTIFICATE_KEY_PATH="/etc/ssl/private/ssl-cert-snakeoil.key"

##
## Set some diagnostic information such that logs accurately reflect where this is coming from
##
ENV SERVER_ENVIRONMENT="production"
ENV SERVER_SERVICE="apache2"

COPY fs/opt/provision/provision.sh /opt/provision/provision.sh

RUN /opt/provision/provision.sh

# These should be overridden by your runtime environment
ENV SERVER_NAME www.example.com
ENV SERVER_ADMIN webmaster@localhost
ENV DOCUMENT_ROOT /var/www/html

# Update the default vhost to one that listens for the environment variables.
ADD fs/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD fs/etc/apache2/conf-enabled/*                 /etc/apache2/conf-enabled/

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
