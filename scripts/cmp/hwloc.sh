#!/bin/bash

VERSION=$1
MAJOR_VERSION=`echo "${VERSION}" | cut -d"." -f 1-2`
NAME=hwloc-${VERSION}
ROOT=/opt/${NAME}
ARC_LINK=https://download.open-mpi.org/release/hwloc/v${MAJOR_VERSION}/${NAME}.tar.gz
CFG_ARGS="CC=gcc"

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} ${CFG_ARGS}
update_env.sh ${ROOT} HWLOC_NAME ${NAME}
update_env.sh ${ROOT} HWLOC_ROOT ${ROOT}
echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
