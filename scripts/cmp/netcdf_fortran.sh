#!/bin/bash

VERSION=$1
LABEL=netcdf-fortran
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}

ARC_LINK=https://github.com/Unidata/${LABEL}/archive/v${VERSION}.tar.gz
CFG_ARGS="CC=gcc FC=gfortran CPPFLAGS=-I${ROOT}/include LDFLAGS=-L${ROOT}/lib"

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} "${CFG_ARGS}" all
update_env.sh ${ROOT} NETCDF_FORTRAN_NAME ${NAME}
update_env.sh ${ROOT} NETCDF_FORTRAN_ROOT ${ROOT}

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
