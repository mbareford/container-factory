#!/bin/bash

VERSION=$1
LABEL=gsl
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}
ARC_LINK=http://mirror.koddos.net/gnu/${LABEL}/${NAME}.tar.gz
CFG_ARGS="CC=gcc"

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} ${CFG_ARGS}
update_env.sh ${ROOT} GSL_NAME ${NAME}
update_env.sh ${ROOT} GSL_ROOT ${ROOT}
echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
