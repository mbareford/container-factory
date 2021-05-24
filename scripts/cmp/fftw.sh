#!/bin/bash

VERSION=$1
NAME=fftw-${VERSION}
ROOT=/opt/${NAME}
ARC_LINK=http://www.fftw.org/${NAME}.tar.gz
CFG_ARGS="CC=gcc CXX=g++ FC=gfortran --enable-mpi --enable-openmp --enable-threads"
CFG_ARGS_FILE="/opt/cfg_args_file.txt"

echo "${CFG_ARGS}" > ${CFG_ARGS_FILE}
echo "${CFG_ARGS} --enable-float" >> ${CFG_ARGS_FILE}
echo "${CFG_ARGS} --enable-shared" >> ${CFG_ARGS_FILE}
echo "${CFG_ARGS} --enable-float --enable-shared" >> ${CFG_ARGS_FILE}
install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} ${CFG_ARGS_FILE}
rm ${CFG_ARGS_FILE}
update_env.sh ${ROOT} FFTW_NAME ${NAME}
update_env.sh ${ROOT} FFTW_ROOT ${ROOT}
echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
