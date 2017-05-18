==============
Apache 2 + PHP
==============

[![Build Status](https://quay.io/repository/littlemanco/apache-php/status "Build Status")](https://quay.io/repository/littlemanco/apache-php/)

Justification
-------------

Yet another PHP stack. There are now more ways to run PHP then there are to serve dinner. However, I'm investigating
going back to the simple Apache2 + mod_php model. The reasons are as follows:

- It's a single process. While this wouldn't matter on a fuller deployment environment (read: VM), Docker & Kubernetes
  have quite a number of very nice properties when dealing with only a single process.
- Apache's PHP performance seems comporable to NGINX + PHP (note: Just PHP; Nginx owns static resources)

Versioning Strategy
-------------------

If you browse the quay.io repo, you'll notice I drifted through various different versioning strategies. At the moment,
I like:

```
${UPSTREAM_VERSION}-${PACKAGE_BUILD_NUMER}+${CONTAINER_BUILD_NUMBER}
```

For example, where the version of PHP is 5.6.30, it is the 10th build and I have made two additional container changes
it will be

```
5.6.30-10+2
```

Docker doesn't understand the "+" character in a tag. Thus, that gets rendered to a "_" character. So the image becomes

```
quay.io/littlemanco/apache-php:5.6.30-10_2
```

Using these
-----------

Go nuts. However, I make no guarantees of their safety / security / usefulness. If you find issues, I'd love it if you
report them, but I can guarantee no timely fixes. Hopefully this stack will get picked up by someone willing to fork
out cash to support it, and I can chip away at improving it.

Containers
----------

The containers come in two versions:

Production
""""""""""

Containers that are built for production.

Development
"""""""""""

Containers built on top of the production containers, but with additional development tools (such as XDEBUG) enabled.

Thinking
--------

I'm not yet sure whether this is a good idea. Unanswered questions are:

- How do we tell which problems are PHPs and which are apaches?
- What are the constraints on using Apache?
- What happens to Apache in when PHP does something insane?
