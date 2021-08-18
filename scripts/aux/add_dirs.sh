#!/bin/bash

# $1 application name
# $2 host name

APP=$1
HOST=$2
SCRIPT_PATH=/opt/scripts/app/${APP}/host/${HOST}

if [ -f ${SCRIPT_PATH}/mkdirs.sh ]; then
  ${SCRIPT_PATH}/mkdirs.sh
fi
