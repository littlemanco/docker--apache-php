# Apache 2 + PHP

[![Build Status](https://quay.io/repository/littlemanco/apache-php/status "Build Status")](https://quay.io/repository/littlemanco/apache-php/)

## Warranty

These were built out of curiousity, but are being used in an increasingly "production like" way. However, they're
maintained without any kind of warranty (implied or otherwise).

If you wish to use them please do so, but at your own risk.

Feel free to report issues.

## Justification

Yet another PHP stack. There are now more ways to run PHP then there are to serve dinner. However, I'm investigating
going back to the simple Apache2 + mod_php model. The reasons are as follows:

- It's a single process. While this wouldn't matter on a fuller deployment environment (read: VM), Docker & Kubernetes
  have quite a number of very nice properties when dealing with only a single process.
- Apache's PHP performance seems comporable to NGINX + PHP (note: Just PHP; Nginx owns static resources)

## Release Strategy

There are three supported release streams:

- 5.6
- 7.0
- 7.1

All based on Debian Stretch. To use an image, you can do something like:

```bash
docker run quay.io/littlemanco/apache-php:7.0-latest
```

This will run the 7.0 stream. They're updated nightly but do not track the minor PHP versions. If hte major is not
sufficiently granular for you to track your project against, I recommend you find another base image.

## Usage

### TLS

Please **DO NOT** use the self signed certificate that is packaged in the container for anything other than testing. It
is fundamentally unsound; the security of a secrecy is based on the existance of a **private** key. Because this 
container is public, the key is not private and intermediary can trivially man in the middle connections.

The HTTPS implementation is designed to make the implementation of SSL connections mediated by new, actually private
certificates easier. To use your own certificates, mount them in with the volume abstraction and modify the environment
variables:

- SERVER_TLS_CERTIFICATE_PATH
- SERVER_TLS_CERTIFICATE_KEY_PATH
