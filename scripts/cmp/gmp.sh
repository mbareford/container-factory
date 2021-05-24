#!/bin/bash

VERSION=$1
LABEL=gmp
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}
ARC_LINK=https://gmplib.org/download/${LABEL}/${NAME}.tar.lz
CFG_ARGS="CC=gcc"

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} ${CFG_ARGS}
update_env.sh ${ROOT} GMP_NAME ${NAME}
update_env.sh ${ROOT} GMP_ROOT ${ROOT}
echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
