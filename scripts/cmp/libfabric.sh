#!/bin/bash

LABEL=libfabric
VERSION=$1
#1.11.1
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}

ARC_LINK=https://github.com/ofiwg/${LABEL/archive/v${VERSION}.tar.gz
CFG_ARGS=

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} ${CFG_ARGS}

update_env.sh ${ROOT} LIBFABRIC_NAME ${NAME}
update_env.sh ${ROOT} LIBFRARIC_ROOT ${ROOT}

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
