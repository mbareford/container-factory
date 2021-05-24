#!/bin/bash

VERSION=$1
LABEL=openblas
ARCLABEL=OpenBLAS
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}

if test -f "/opt/env.sh"; then
  . /opt/env.sh
fi

mkdir ${ROOT}
cd ${ROOT}

download_src.sh https://github.com/xianyi/${ARCLABEL}/archive/v${VERSION}.tar.gz ${NAME}

cd ${NAME}

export CXX=mpic++
export CC=mpicc
export FC=mpif90

mkdir build
cd build

cmake ../ -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${ROOT}
make install
make clean

cmake ../ -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=${ROOT}
make install
make clean

cd ${ROOT}
rm -rf ${NAME}

setup_env.sh ${ROOT}
update_env.sh ${ROOT} OPENBLAS_NAME ${NAME}
update_env.sh ${ROOT} OPENBLAS_ROOT ${ROOT}

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
