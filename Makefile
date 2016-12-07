# Task runner

.PHONY: help build

.DEFAULT_GOAL := help

SHELL := /bin/bash

# http://stackoverflow.com/questions/1404796/how-to-get-the-latest-tag-name-in-current-branch-in-git
APP_VERSION := $(shell git describe --abbrev=0)

#PROJECT_NS   := apache-php
#CONTAINER_NS := apache-php
GIT_HASH     := $(shell git rev-parse --short HEAD)

ANSI_TITLE        := '\e[1;32m'
ANSI_CMD          := '\e[0;32m'
ANSI_TITLE        := '\e[0;33m'
ANSI_SUBTITLE     := '\e[0;37m'
ANSI_WARNING      := '\e[1;31m'
ANSI_OFF          := '\e[0m'

PATH_DOCS                := $(shell pwd)/docs
PATH_BUILD_CONFIGURATION := $(shell pwd)/build

TIMESTAMP := $(shell date "+%s")

help: ## Show this menu
	@echo -e $(ANSI_TITLE)PHP + Apache$(ANSI_OFF)$(ANSI_SUBTITLE)" - For a simpler (read: sane) process model"$(ANSI_OFF)
	@echo -e $(ANSI_TITLE)Commands:$(ANSI_OFF)
	@grep -E '^[a-zA-Z_-%]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "    \033[32m%-30s\033[0m %s\n", $$1, $$2}'

image: ## ${VERSION} | Create the docker image
	if [[ -z "${VERSION}" ]]; then echo "Need to supply a version." && exit 1; fi
	docker build \
	    --no-cache \
	    -f ${VERSION}/Dockerfile \
	    -t quay.io/littlemanco/apache-php:${VERSION}-$(GIT_HASH) \
	    .
	docker build \
	    --no-cache \
	    -f ${VERSION}/Dockerfile \
	    -t quay.io/littlemanco/apache-php:${VERSION}-latest \
	    .
push: ## ${VERSION} | Push the docker image to quay.io
	if [[ -z "${VERSION}" ]]; then echo "Need to supply a version." && exit 1; fi;
	docker push quay.io/littlemanco/apache-php:${VERSION}-$(GIT_HASH)
	docker push quay.io/littlemanco/apache-php:${VERSION}-latest
all: image push ## Create and push the docker image
	echo "Done."
