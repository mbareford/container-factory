#!/bin/bash

HOST=$1
VERSION=$2
MPI_LABEL=$3
COMPILER_LABEL=$4

LABEL=ramses
NAME=${LABEL}-${VERSION}
ROOT=/opt/app/${LABEL}
HOST_PATH=${HOST}/${MPI_LABEL}/${COMPILER_LABEL}
SCRIPTS_ROOT=/opt/scripts/app/${LABEL}/host/${HOST_PATH}
BUILD_ROOT=${ROOT}/${NAME}/bin
INSTALL_ROOT=${ROOT}/${VERSION}/${HOST_PATH}
LOG_ROOT=/opt/logs


# set the build environment
. ${SCRIPTS_ROOT}/env.sh


# get the host-specific makefile
cp ${SCRIPTS_ROOT}/Makefile.${VERSION} ${BUILD_ROOT}/Makefile 

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


# build
cd ${BUILD_ROOT}
make -s clean
make &> ${MAKE_LOG}
make -s clean


# install
mkdir -p ${INSTALL_ROOT}/bin
cp ${BUILD_ROOT}/${LABEL}3d ${INSTALL_ROOT}/bin/


# record
currentDateTime=`date +"%Y-%m-%d %T"`
echo "    ${currentDateTime}: Built ${LABEL} ${VERSION} (${MPI_LABEL}-${COMPILER_LABEL}) on ${HOST}" >> /.singularity.d/runscript.help
echo "                         (${MAKE_LOG})" >> /.singularity.d/runscript.help
echo "" >> /.singularity.d/runscript.help
