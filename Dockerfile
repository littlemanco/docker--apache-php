FROM debian:stretch-slim

ARG TINI_VERSION="v0.17.0"
ARG PHP_VERSION

COPY fs/opt/provision/provision.sh /opt/provision/provision.sh

RUN /opt/provision/provision.sh

# These should be overridden by your runtime environment
ENV SERVER_NAME www.example.com
ENV SERVER_ADMIN webmaster@localhost
ENV DOCUMENT_ROOT /var/www/html

# Update the default vhost to one that listens for the environment variables.
ADD fs/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD fs/etc/apache2/conf-enabled/gzip.conf       /etc/apache2/conf-enabled/gzip.conf

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
