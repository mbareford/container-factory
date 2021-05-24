#!/bin/bash

LABEL=boost
VERSION=$1
VERSION_ALT=`echo "${VERSION}" | tr . _`
NAME=${LABEL}-${VERSION}
ARCHIVE=${LABEL}_${VERSION_ALT}
ROOT=/opt/${NAME}

if test -f "/opt/env.sh"; then
  . /opt/env.sh
fi

mkdir -p ${ROOT}
cd ${ROOT}

download_src.sh https://dl.bintray.com/boostorg/release/${VERSION}/source/${ARCHIVE}.tar.bz2 ${NAME}

cd ${NAME}

./bootstrap.sh --prefix=${ROOT}
./b2 install

cd ${ROOT}
rm -rf ${NAME}
setup_env.sh ${ROOT}

update_env.sh ${ROOT} BOOST_NAME ${NAME}
update_env.sh ${ROOT} BOOST_ROOT ${ROOT}
echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
