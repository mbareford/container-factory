#!/bin/bash

VERSION=$1
NAME=cmake-${VERSION}
ROOT=/opt/${NAME}
ARC_LINK=https://github.com/Kitware/CMake/releases/download/v${VERSION}/${NAME}.tar.gz
CFG_ARGS="CC=gcc CXX=g++"

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} "${CFG_ARGS}"
update_env.sh ${ROOT} CMAKE_NAME ${NAME}
update_env.sh ${ROOT} CMAKE_ROOT ${ROOT}
echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
