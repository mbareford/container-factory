#!/bin/bash

VERSION=$2
LABEL=$1
NAME=${LABEL}-${VERSION}
ROOT=/opt/app/${LABEL}

mkdir -p ${ROOT}
cd ${ROOT}

svn co https://forge.ipsl.jussieu.fr/${LABEL}/svn/${LABEL^^}/releases/r${VERSION:0:3}/r${VERSION} ${ROOT}/${NAME}

sed -i "s/FC_MODSEARCH => '',/FC_MODSEARCH => '-J',/g" ${ROOT}/${NAME}/ext/FCM/lib/Fcm/Config.pm
