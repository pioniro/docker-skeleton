#!/usr/bin/env bash

groupadd -r -g ${APPLICATION_GROUP:=1000} ${APPLICATION_GROUP_NAME:=server} \
  && useradd -r -u ${APPLICATION_USER:=1000} -g ${APPLICATION_GROUP:=1000} -m\
   -s /bin/false ${APPLICATION_USER_NAME:=server}