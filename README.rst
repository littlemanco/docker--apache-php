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


