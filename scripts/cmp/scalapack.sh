#!/bin/bash

VERSION=$1
LABEL=scalapack
NAME=${LABEL}-${VERSION}
ROOT=/opt/${NAME}

if test -f "/opt/env.sh"; then
  . /opt/env.sh
fi

mkdir ${ROOT}
cd ${ROOT}

download_src.sh https://github.com/Reference-ScaLAPACK/${LABEL}/archive/v${VERSION}.tar.gz ${NAME}

cd ${NAME}

export CXX=mpic++
export CC=mpicc
export FC=mpif90

mkdir build
cd build

cmake ../ -DBUILD_SHARED_LIBS=ON -DBLAS_LIBRARIES=${LAPACK_ROOT}/lib/libblas.so -DLAPACK_LIBRARIES=${LAPACK_ROOT}/lib/liblapack.so -DCMAKE_INSTALL_PREFIX=${ROOT}
make install
make clean

cmake ../ -DBUILD_SHARED_LIBS=OFF -DBLAS_LIBRARIES=${LAPACK_ROOT}/lib/libblas.so -DLAPACK_LIBRARIES=${LAPACK_ROOT}/lib/liblapack.so -DCMAKE_INSTALL_PREFIX=${ROOT}
make install
make clean

cd ${ROOT}
rm -rf ${NAME}
rm -rf ${ROOT}/lib/cmake

setup_env.sh ${ROOT}
update_env.sh ${ROOT} SCALAPACK_NAME ${NAME}
update_env.sh ${ROOT} SCALAPACK_ROOT ${ROOT}

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
