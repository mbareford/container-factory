#!/bin/bash

declare -a hostpaths=("/scratch" "/lustre1" "/lustre2" "/lustre3" "/lustre4" "/lustre5" \
    "/genehunter" "/gelustre" "/clincloud" "/mrc-bsu" "/mtg" \
    "/rds-d1" "/rds-d2" "/rds-d3" "/rds-d4" "/rds-d5" "/rds" \
    "/rcs1" "/rcs2" "/rcs3" "/rcs" "/rfs" "/local" "/ramdisks" \
    "/usr/local/Cluster-Apps" )

HOST=CSD3
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
