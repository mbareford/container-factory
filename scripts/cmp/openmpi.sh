#!/bin/bash

VERSION=$1
MAJOR_VERSION=`echo "${VERSION}" | cut -d"." -f 1-2`
NAME=openmpi-${VERSION}
ROOT=/opt/${NAME}

ARC_LINK=https://download.open-mpi.org/release/open-mpi/v${MAJOR_VERSION}/${NAME}.tar.gz
CFG_ARGS="CC=gcc CXX=g++ FC=gfortran --enable-mpi1-compatibility --enable-mpi-fortran"

for hwloc_path in /opt/hwloc-*; do
  if [ -d "${hwloc_path}" ]; then
    CFG_ARCGS="${CFG_ARGS} --with-hwloc=${hwloc_path}"
    break
  fi
done

for ucx_path in /opt/ucx-*; do
  if [ -d "${ucx_path}" ]; then
    CFG_ARCGS="${CFG_ARGS} --with-ucx=${ucx_path}"
    break
  fi
done

for libfabric_path in /opt/libfabric-*; do
  if [ -d "${libfabric_path}" ]; then
    CFG_ARCGS="${CFG_ARGS} --with-libfabric=${libfabric_path} --with-verbs"
    break
  fi
done

if [ ! -z "${2}" ]; then
  # extra configure arguments have been supplied
  CFG_ARCGS="${CFG_ARGS} ${2}"
fi

install_cmp.sh ${NAME} ${ROOT} ${ARC_LINK} "${CFG_ARGS}"

update_env.sh ${ROOT} OPENMPI_NAME ${NAME}
update_env.sh ${ROOT} OPENMPI_ROOT ${ROOT}
update_env.sh ${ROOT} MPI_HOME ${ROOT}
update_env.sh ${ROOT} MPI_RUN ${ROOT}/bin/mpirun

# add support for running hybrid mpi
update_env.sh ${ROOT} OMPI_DIR ${ROOT}
update_env.sh ${ROOT} SINGULARITY_OMPI_DIR ${ROOT}

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
