#!/bin/bash
  
declare -a hostpaths=("/lustre/sw" "/opt/hpe" "/etc/libibverbs.d")

HOST=Cirrus
PATH_LOG=/opt/hostpath.log

if [ ! -f ${PATH_LOG} ]; then
  touch ${PATH_LOG}
fi

for hpath in "${hostpaths[@]}"; do
  mkdir -p ${hpath}
  LOG_LINE="${HOST}: ${hpath}"
  if ! grep -q "${LOG_LINE}" ${PATH_LOG}; then
    echo "${LOG_LINE}" >> ${PATH_LOG}
  fi
done
