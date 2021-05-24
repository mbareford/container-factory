#!/bin/bash

VERSION=$2
LABEL=$1
NAME=${LABEL}-${VERSION}
ROOT=/opt/app/${LABEL}

mkdir -p ${ROOT}/${NAME}
cd ${ROOT}/${NAME}

mv /opt/${NAME}.tar.gz ${ROOT}/${NAME}/
tar -xzf ${NAME}.tar.gz
rm ${NAME}.tar.gz
