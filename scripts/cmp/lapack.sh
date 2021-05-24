#!/bin/bash

VERSION=$1
LABEL=lapack
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}

if test -f "/opt/env.sh"; then
  . /opt/env.sh
fi

mkdir ${ROOT}
cd ${ROOT}

download_src.sh wget https://github.com/Reference-LAPACK/${LABEL}/archive/v${VERSION}.tar.gz ${NAME}

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
rm -rf ${ROOT}/lib/cmake

setup_env.sh ${ROOT}
update_env.sh ${ROOT} LAPACK_NAME ${NAME}
update_env.sh ${ROOT} LAPACK_ROOT ${ROOT}

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
