ROOT_DIR       := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VARIABLES_FILE  = $(ROOT_DIR)/variables.env
SHELL          := $(shell which bash)
ARGS            = $(filter-out $@,$(MAKECMDGOALS))

.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
default: up;             # default target
Makefile: ;              # skip prerequisite discovery

build: check
	docker-compose build --no-cache

pull:
	docker pull mongo:3.4
	docker pull postgres:9.6-alpine
	docker pull mysql:5.7
	docker pull memcached:1.4-alpine
	docker pull redis:3.2-alpine
	docker pull elasticsearch:5.2-alpine
	docker pull nginx:latest
	docker pull php:7.1.9-fpm

up: check
	docker-compose up -d

start: check
	docker-compose start

stop:
	docker-compose stop

status:
	docker-compose ps

reset: check stop clean build up

check:
ifeq ($(wildcard $(VARIABLES_FILE)),)
	$(error Failed to locate the $(VARIABLES_FILE) file.)
endif
	docker-compose config -q

version:
	docker-compose version

bash: shell

shell:
	docker exec -it $$(docker-compose ps -q app) /bin/bash

clean: stop
	docker-compose down

%:
	@:
