#!/bin/bash

lscpu &> /opt/facinfo

SCRIPTS_ARCHIVE=scripts.tar.gz
if [ -f "/opt/$SCRIPTS_ARCHIVE" ]; then
  cd /opt
  tar -xzf $SCRIPTS_ARCHIVE
  rm $SCRIPTS_ARCHIVE
  chmod -R a+rx /opt/scripts
fi

ROOT=/opt/scripts
SCRIPT_PATHS=${ROOT}/chk:${ROOT}/aux:${ROOT}/os:${ROOT}/cmp:${ROOT}/cmp/miniconda:${ROOT}/app

for subdir in ${ROOT}/app/*/; do
  subdir=${subdir%*/}
  SCRIPT_PATHS=${SCRIPT_PATHS}:${subdir}
done

export PATH=${SCRIPT_PATHS}:${PATH}
echo "export PATH=${SCRIPT_PATHS}:\$PATH" >> $SINGULARITY_ENVIRONMENT
