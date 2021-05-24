#!/bin/bash

VERSION=$1
LABEL=lzip
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}
ARC_LINK=https://download.savannah.nongnu.org/releases/${LABEL}/${NAME}.tar.gz
CFG_ARGS=

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} ${CFG_ARGS}
echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
