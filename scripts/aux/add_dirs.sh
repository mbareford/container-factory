#!/bin/bash

# $1 application name
# $2 host name

APP=$1
HOST=$2
SCRIPT_PATH=/opt/scripts/app/${APP}/host/${HOST}

PATH_LOG=/opt/logs/hostpath.log
if [ ! -f ${PATH_LOG} ]; then
  touch ${PATH_LOG}
fi

if [ -f ${SCRIPT_PATH}/mkdirs.sh ]; then
  source ${SCRIPT_PATH}/mkdirs.sh

  if [ ! -f ${PATH_LOG} ]; then
    touch ${PATH_LOG}
  fi

  for hpath in "${hostpaths[@]}"; do
    mkdir -p ${hpath}
    if [ -d ${hpath} ]; then
      LOG_LINE="${HOST}: ${hpath}"
      if ! grep -q "${LOG_LINE}" ${PATH_LOG}; then
        echo "${LOG_LINE}" >> ${PATH_LOG}
      fi
    fi
  done
fi
