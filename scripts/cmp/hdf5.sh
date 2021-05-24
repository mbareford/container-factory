#!/bin/bash

VERSION=$1
MAJOR_VERSION=`echo "${VERSION}" | cut -d"." -f 1-2`
MINOR_VERSION=`echo "${VERSION}" | cut -d"." -f 3`
LABEL=hdf5
MAJOR_NAME=${LABEL}-${MAJOR_VERSION}
NAME=${MAJOR_NAME}.${MINOR_VERSION}
ROOT=/opt/${NAME}
ARC_LINK=https://support.hdfgroup.org/ftp/HDF5/releases/${MAJOR_NAME}/${NAME}/src/${NAME}.tar.gz
CFG_ARGS="CC=mpicc --enable-parallel"

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} "${CFG_ARGS}"
update_env.sh ${ROOT} HDF5_NAME ${NAME}
update_env.sh ${ROOT} HDF5_ROOT ${ROOT}
echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
