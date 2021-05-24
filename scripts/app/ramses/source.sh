#!/bin/bash

VERSION=$2
BRANCH=`echo "stable_$VERSION" | tr . _`
LABEL=$1
NAME=${LABEL}-${VERSION}
ROOT=/opt/app/${LABEL}

mkdir -p ${ROOT}
cd ${ROOT}

git clone --branch ${BRANCH} https://bitbucket.org/rteyssie/${LABEL}.git 
mv ${LABEL} ${NAME}

cd ${NAME}/bin
cp Makefile Makefile.0
