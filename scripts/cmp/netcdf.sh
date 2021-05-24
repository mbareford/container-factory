#!/bin/bash

VERSION=$1
LABEL=netcdf
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}
ARC_LINK=https://github.com/Unidata/${LABEL}-c/archive/v${VERSION}.tar.gz
CFG_ARGS="CC=gcc MPICC_CC=gcc MPICXX_CXX=g++ --disable-dap --enable-parallel-tests --enable-netcdf-4 CPPFLAGS=-I${HDF5_ROOT}/include LDFLAGS=-L${HDF5_ROOT}/lib"

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} "${CFG_ARGS}" all
update_env.sh ${ROOT} NETCDF_NAME ${NAME}
update_env.sh ${ROOT} NETCDF_ROOT ${ROOT}

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
