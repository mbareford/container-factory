#!/bin/bash

LABEL=ucx
VERSION=$1
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}

ARC_LINK=https://github.com/openucx/${LABEL}/archive/v${VERSION}.tar.gz
CFG_ARGS=

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} ${CFG_ARGS}

update_env.sh ${ROOT} UCX_NAME ${NAME}
update_env.sh ${ROOT} UCX_ROOT ${ROOT}

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
