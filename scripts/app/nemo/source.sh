#!/bin/bash

XIOS_VERSION=$2
XIOS_LABEL=$1
XIOS_NAME=${XIOS_LABEL}-${XIOS_VERSION}
XIOS_ROOT=/opt/cmp/${XIOS_LABEL}

mkdir -p ${XIOS_ROOT}
cd ${XIOS_ROOT}

svn co https://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/branchs/${XIOS_NAME} ${XIOS_ROOT}/${XIOS_NAME}


NEMO_VERSION=$4
NEMO_LABEL=$3
NEMO_NAME=${NEMO_LABEL}-${NEMO_VERSION}
NEMO_ROOT=/opt/app/${NEMO_LABEL}

mkdir -p ${NEMO_ROOT}
cd ${NEMO_ROOT}

svn co https://forge.ipsl.jussieu.fr/${NEMO_LABEL}/svn/${NEMO_LABEL^^}/releases/r${NEMO_VERSION:0:3}/r${NEMO_VERSION} ${NEMO_ROOT}/${NEMO_NAME}

sed -i "s/FC_MODSEARCH => '',/FC_MODSEARCH => '-J',/g" ${NEMO_ROOT}/${NEMO_NAME}/ext/FCM/lib/Fcm/Config.pm
