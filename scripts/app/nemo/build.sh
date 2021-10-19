#!/bin/bash

HOST=$1
VERSION=$2
REF_LABEL=$3
CFG_LABEL=$4
MPI_LABEL=$5
COMPILER_LABEL=$6
ARCH_LABEL=${HOST}-${MPI_LABEL}-${COMPILER_LABEL}

LABEL=nemo
NAME=${LABEL}-${VERSION}
ROOT=/opt/app/${LABEL}
BUILD_PATH=${ROOT}/${NAME}
HOST_PATH=${HOST}/${MPI_LABEL}/${COMPILER_LABEL}
REF_PATH=${BUILD_PATH}/cfgs/${REF_LABEL}
CFG_PATH=${BUILD_PATH}/cfgs/${CFG_LABEL}
SHARED_PATH=${BUILD_PATH}/cfgs/shared
EXP00_PATH=${CFG_PATH}/EXP00
SCRIPTS_HOST_ROOT=/opt/scripts/app/${LABEL}/host/${HOST_PATH}
SCRIPTS_CFG_ROOT=/opt/scripts/app/${LABEL}/cfg/${REF_LABEL}
INSTALL_ROOT=${ROOT}/${VERSION}/${HOST_PATH}/${CFG_LABEL}
LOG_ROOT=/opt/logs


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


cd ${BUILD_PATH}


# set the build environment
. ${SCRIPTS_HOST_ROOT}/env.sh

# get the appropriate fcm file for architecture
cp ${SCRIPTS_HOST_ROOT}/arch.fcm ${BUILD_PATH}/arch/arch-${ARCH_LABEL}.fcm

# check if any pre-build changes are required
if [ -f ${SCRIPTS_CFG_ROOT}/pre_build.sh ]; then
  ${SCRIPTS_CFG_ROOT}/pre_build.sh ${REF_PATH}
fi

rm -rf ${CFG_PATH}

./makenemo -n ${CFG_LABEL} -r ${REF_LABEL} -m ${ARCH_LABEL} -j 1 &> ${MAKE_LOG}

# set the executable file
rm ${EXP00_PATH}/nemo
cp ${CFG_PATH}/BLD/bin/nemo.exe ${EXP00_PATH}/nemo

# check if any extra post-build changes are required
if [ -f ${SCRIPTS_CFG_ROOT}/post_build.sh ]; then
  ${SCRIPTS_CFG_ROOT}/post_build.sh ${EXP00_PATH} ${SHARED_PATH}
fi


mv ${EXP00_PATH} ${INSTALL_ROOT}
echo "" >> ${MAKE_LOG}
echo "NEMO executable and ${CFG_LABEL} input files written to ${INSTALL_ROOT}." >> ${MAKE_LOG}


# record
currentDateTime=`date +"%Y-%m-%d %T"`
echo "    ${currentDateTime}: Built ${LABEL} ${VERSION} (${MPI_LABEL}-${COMPILER_LABEL}) for ${CFG_LABEL} (${REF_LABEL}) on ${HOST}" >> /.singularity.d/runscript.help
echo "                         (${MAKE_LOG})" >> /.singularity.d/runscript.help
echo "" >> /.singularity.d/runscript.help
