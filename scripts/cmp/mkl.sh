#!/bin/bash

VERSION=$1
NAME=mkl
ROOT=/opt/intel/${NAME}

mkdir -p /opt/keys
cd /opt/keys

wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB

sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'
apt-get -y update

# https://software.intel.com/en-us/articles/installing-intel-free-libs-and-python-apt-repo
apt-get -y install intel-mkl-64bit-${VERSION}

# make mkl the default for blas and lapack, commented out for now
#update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so     libblas.so-x86_64-linux-gnu      /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
#update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so.3   libblas.so.3-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
#update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so   liblapack.so-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
#update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so.3 liblapack.so.3-x86_64-linux-gnu  /opt/intel/mkl/lib/intel64/libmkl_rt.so 50

echo "/opt/intel/lib/intel64" > /etc/ld.so.conf.d/mkl.conf
echo "${ROOT}/lib/intel64" >> /etc/ld.so.conf.d/mkl.conf
ldconfig

if test -f "/opt/env.sh"; then
  . /opt/env.sh
fi

echo "export MKLROOT=${ROOT}" > ${ROOT}/env.sh
. ${ROOT}/env.sh

export MKLVARS_ARCHITECTURE=intel64
export MKLVARS_INTERFACE=lp64
shift $#
. ${ROOT}/bin/mklvars.sh

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT

cd ${MKLROOT}/interfaces/blas95
make clean INSTALL_DIR=${MKLROOT}/interfaces/blas95
make libintel64 FC=gfortran interface=lp64 INSTALL_DIR=${MKLROOT}/interfaces/blas95

cd ${MKLROOT}/interfaces/lapack95
make clean INSTALL_DIR=${MKLROOT}/interfaces/lapack95
make libintel64 FC=gfortran interface=lp64 INSTALL_DIR=${MKLROOT}/interfaces/lapack95

cd ${MKLROOT}/interfaces/mklmpi
sed -i "/#define OMPI_ENABLE_MPI1_COMPAT 0/c #define OMPI_ENABLE_MPI1_COMPAT 1" $OPENMPI_ROOT/include/mpi.h
make libintel64 MPICC="mpicc -DOMPI_IMPORTS -DOPAL_IMPORTS -DORTE_IMPORTS" interface=lp64 INSTALL_DIR=${MKLROOT}/interfaces/mklmpi

cd ${MKLROOT}/include
gfortran -fautomatic -J${MKLROOT}/include -c -o ${MKLROOT}/include/mkl_service.o ./mkl_service.f90

cd ${MKLROOT}/include/intel64/lp64
mkdir arc
mv *.mod ./arc/
cp ${MKLROOT}/interfaces/blas95/include/intel64/lp64/*.mod ./
cp ${MKLROOT}/interfaces/lapack95/include/intel64/lp64/*.mod ./
cp ${MKLROOT}/include/mkl_service.mod ./

cd ${MKLROOT}/lib/intel64/
mkdir arc
mv libmkl_blas95_lp64.a ./arc/
mv libmkl_lapack95_lp64.a ./arc/
mv libmkl_blacs_openmpi_lp64.a ./arc/
cp /opt/intel/mkl/interfaces/blas95/lib/intel64/libmkl_blas95_lp64.a ./
cp /opt/intel/mkl/interfaces/lapack95/lib/intel64/libmkl_lapack95_lp64.a ./
cp /opt/intel/mkl/interfaces/mklmpi/libmkl_blacs_custom_lp64.a ./libmkl_blacs_openmpi_lp64.a
