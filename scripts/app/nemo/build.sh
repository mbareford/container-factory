#!/bin/bash

HOST=$1
XIOS_VERSION=$2
NEMO_VERSION=$3
REF_LABEL=$4
CFG_LABEL=$5
MPI_LABEL=$6
COMPILER_LABEL=$7
ARCH_LABEL=${HOST}-${MPI_LABEL}-${COMPILER_LABEL}

XIOS_LABEL=xios
XIOS_NAME=${XIOS_LABEL}-${XIOS_VERSION}
XIOS_ROOT=/opt/cmp/${XIOS_LABEL}

NEMO_LABEL=nemo
NEMO_NAME=${NEMO_LABEL}-${NEMO_VERSION}
NEMO_ROOT=/opt/app/${NEMO_LABEL}
NEMO_BUILD_PATH=${NEMO_ROOT}/${NEMO_NAME}
HOST_PATH=${HOST}/${MPI_LABEL}/${COMPILER_LABEL}
REF_PATH=${NEMO_BUILD_PATH}/cfgs/${REF_LABEL}
CFG_PATH=${NEMO_BUILD_PATH}/cfgs/${CFG_LABEL}
NEMO_SHARED_PATH=${NEMO_BUILD_PATH}/cfgs/SHARED
NEMO_EXP00_PATH=${CFG_PATH}/EXP00
SCRIPTS_HOST_ROOT=/opt/scripts/app/${NEMO_LABEL}/host/${HOST_PATH}
SCRIPTS_XIOS_ROOT=${SCRIPTS_HOST_ROOT}/${XIOS_LABEL}/${XIOS_VERSION}
SCRIPTS_CFG_ROOT=/opt/scripts/app/${NEMO_LABEL}/cfg/${REF_LABEL}
XIOS_INSTALL_ROOT=${XIOS_ROOT}/${XIOS_VERSION}/${HOST_PATH}
NEMO_INSTALL_ROOT=${NEMO_ROOT}/${NEMO_VERSION}/${HOST_PATH}
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


# set the build environment
. ${SCRIPTS_HOST_ROOT}/env.sh


# build XIOS
###############################################################
cd ${XIOS_ROOT}/${XIOS_NAME}
cp ${SCRIPTS_XIOS_ROOT}/arch.env ./arch/arch-${ARCH_LABEL}.env
cp ${SCRIPTS_XIOS_ROOT}/arch.fcm ./arch/arch-${ARCH_LABEL}.fcm
cp ${SCRIPTS_XIOS_ROOT}/arch.path ./arch/arch-${ARCH_LABEL}.path

./make_xios --full --arch ${ARCH_LABEL} &> ${MAKE_LOG}
echo "" >> ${MAKE_LOG}
echo "" >> ${MAKE_LOG}

rm -rf ${XIOS_INSTALL_ROOT}
mkdir -p ${XIOS_INSTALL_ROOT}
cp -r ./bin ${XIOS_INSTALL_ROOT}/
cp -r ./inc ${XIOS_INSTALL_ROOT}/
cp -r ./lib ${XIOS_INSTALL_ROOT}/
rm ${XIOS_INSTALL_ROOT}/bin/fcm_env.ksh
###############################################################


cd ${NEMO_BUILD_PATH}


# get the appropriate fcm file for architecture
cp ${SCRIPTS_HOST_ROOT}/arch.fcm ${NEMO_BUILD_PATH}/arch/arch-${ARCH_LABEL}.fcm

# check if any pre-build changes are required
if [ -f ${SCRIPTS_CFG_ROOT}/pre_build.sh ]; then
  ${SCRIPTS_CFG_ROOT}/pre_build.sh ${REF_PATH}
fi

rm -rf ${CFG_PATH}

./makenemo -n ${CFG_LABEL} -r ${REF_LABEL} -m ${ARCH_LABEL} -j 1 &>> ${MAKE_LOG}

# remove the executable file
rm ${NEMO_EXP00_PATH}/nemo

# check if any extra post-build changes are required
if [ -f ${SCRIPTS_CFG_ROOT}/post_build.sh ]; then
  ${SCRIPTS_CFG_ROOT}/post_build.sh ${NEMO_EXP00_PATH} ${NEMO_SHARED_PATH}
fi

# install
mkdir -p ${NEMO_INSTALL_ROOT}
rm -rf ${NEMO_INSTALL_ROOT}/${CFG_LABEL}
mv ${NEMO_EXP00_PATH} ${NEMO_INSTALL_ROOT}/${CFG_LABEL}
echo "" &>> ${MAKE_LOG}
echo "NEMO ${CFG_LABEL} input files written to ${NEMO_INSTALL_ROOT}/${CFG_LABEL}/ ." &>> ${MAKE_LOG}
echo "XIOS executable and library written to ${XIOS_INSTALL_ROOT}/ ." &>> ${MAKE_LOG}


# record
currentDateTime=`date +"%Y-%m-%d %T"`
echo "    ${currentDateTime}: Built ${XIOS_LABEL} ${XIOS_VERSION} and ${NEMO_LABEL} ${NEMO_VERSION} (${MPI_LABEL}-${COMPILER_LABEL}) for ${CFG_LABEL} (${REF_LABEL}) on ${HOST}" >> /.singularity.d/runscript.help
echo "                         (${MAKE_LOG})" >> /.singularity.d/runscript.help
echo "" >> /.singularity.d/runscript.help
