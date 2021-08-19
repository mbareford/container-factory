#!/bin/bash

SCRIPTS_ROOT=$1
IMG_PATH=$2
APP=$3
HOST=$4

SCRIPTS_SNG=${SCRIPTS_ROOT}/fac/singularity

. ${SCRIPTS_SNG}/get_latest_suffix.sh
get_latest_suffix ${IMG_PATH} ${APP}
next_suffix=`expr ${suffix} + 1`

if [ -f ${SCRIPTS_ROOT}/app/${APP}/host/${HOST}/mkdirs.sh ]; then
  echo "Creating host-specific folders within ${APP} container in preparation for targeting ${HOST}..."
  cp ${IMG_PATH}/${APP}.sif.${suffix} ${IMG_PATH}/${APP}.sif.${next_suffix}
  ${SCRIPTS_SNG}/add_dirs.sh ${IMG_PATH}/${APP}.sif.${next_suffix} ${APP} ${HOST}
  echo ""
fi
