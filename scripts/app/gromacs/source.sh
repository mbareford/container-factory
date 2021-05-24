#!/bin/bash

VERSION=$2
LABEL=$1
NAME=${LABEL}-${VERSION}
ROOT=/opt/app/${LABEL}

mkdir -p ${ROOT}
cd ${ROOT}

wget https://ftp.gromacs.org/${LABEL}/${NAME}.tar.gz
tar -xzf ${NAME}.tar.gz
rm ${NAME}.tar.gz
