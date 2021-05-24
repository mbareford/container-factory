#!/bin/bash

VERSION=$1
LABEL=eigen
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}

if test -f "/opt/env.sh"; then
  . /opt/env.sh
fi

mkdir ${ROOT}
cd ${ROOT}

download_src.sh https://gitlab.com/libeigen/${LABEL}/-/archive/${VERSION}/${NAME}.tar.gz ${NAME}

cd ${NAME}

export CXX=mpic++
export CC=mpicc
export FC=mpif90

mkdir build
cd build

cmake ../ -DCMAKE_INSTALL_PREFIX=${ROOT}
make install

cd ${ROOT}
rm -rf ${NAME}

setup_env.sh ${ROOT}
update_env.sh ${ROOT} EIGEN_NAME ${NAME}
update_env.sh ${ROOT} EIGEN_ROOT ${ROOT}

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
