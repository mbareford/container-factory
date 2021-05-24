#!/bin/bash

LABEL=rdma-core
VERSION=$1
# 31.1
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}

ARC_LINK=https://github.com/linux-rdma/${LABEL}/archive/v${VERSION}.tar.gz
CFG_ARGS=

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} ${CFG_ARGS}

update_env.sh ${ROOT} RDMA-CORE_NAME ${NAME}
update_env.sh ${ROOT} RDMA-CORE_ROOT ${ROOT}

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
