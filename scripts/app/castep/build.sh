#!/bin/bash

HOST=$1
VERSION=$2
MPI_LABEL=$3
COMPILER_LABEL=$4

LABEL=castep
NAME=${LABEL}-${VERSION}
ROOT=/opt/app/${LABEL}
HOST_PATH=${HOST}/${MPI_LABEL}/${COMPILER_LABEL}
SCRIPTS_ROOT=/opt/scripts/app/${LABEL}/host/${HOST_PATH}
BUILD_ROOT=${ROOT}/${NAME}
INSTALL_ROOT=${ROOT}/${VERSION}/${HOST_PATH}/bin
LOG_ROOT=/opt/logs
ARCH_LABEL=linux_x86_64_${COMPILER_LABEL}


# set the build environment
. ${SCRIPTS_ROOT}/env.sh


# set make log name
mkdir -p ${LOG_ROOT}
if [ -f "${LOG_ROOT}/.make" ]; then
  makecnt=`cat ${LOG_ROOT}/.make`
  makecnt=`expr ${makecnt} + 1`
else
  makecnt="1"
fi
MAKE_LOG=${LOG_ROOT}/make.log.${makecnt}
echo "${makecnt}" > ${LOG_ROOT}/.make


# setup makefile and platform config
cp ${SCRIPTS_ROOT}/Makefile ${BUILD_ROOT}/
cp ${SCRIPTS_ROOT}/Makefile.optados.src ${BUILD_ROOT}/Utilities/optados/src/Makefile
cp ${SCRIPTS_ROOT}/include_rules.mk ${BUILD_ROOT}/obj/
cp ${SCRIPTS_ROOT}/${ARCH_LABEL}.mk ${BUILD_ROOT}/obj/platforms/
cp ${SCRIPTS_ROOT}/${ARCH_LABEL}-XT.mk ${BUILD_ROOT}/obj/platforms/
cp ${SCRIPTS_ROOT}/${ARCH_LABEL%?}.mk ${BUILD_ROOT}/obj/platforms/
cp ${SCRIPTS_ROOT}/${ARCH_LABEL%?}-XT.mk ${BUILD_ROOT}/obj/platforms/
unset CPU
mkdir -p ${INSTALL_ROOT}
cd ${BUILD_ROOT}

# compile and install
FC=gfortran CC=gcc make CASTEP_ARCH=${ARCH_LABEL}
make INSTALL_DIR=${INSTALL_ROOT} install
make CASTEP_ARCH=${ARCH_LABEL} clean
rm -rf ${BUILD_ROOT}/obj/${ARCH_LABEL%?}--*


# record
currentDateTime=`date +"%Y-%m-%d %T"`
echo "    ${currentDateTime}: Built ${LABEL} ${VERSION} (${MPI_LABEL}-${COMPILER_LABEL}) on ${HOST}" >> /.singularity.d/runscript.help
echo "                         (${MAKE_LOG})" >> /.singularity.d/runscript.help
echo "" >> /.singularity.d/runscript.help
