#!/bin/bash

# $1 archive web link
# $2 component name

# ./scripts/aux/download_src.sh http://mirror.koddos.net/gnu/gsl/gsl-2.5.tar.gz gsl-2.5
# ./scripts/aux/download_src.sh https://gmplib.org/download/gmp/gmp-6.1.2.tar.lz gmp-6.1.2
# ./scripts/aux/download_src.sh https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.bz2 boost-1.73.0

ARC_LINK=$1
NAME=$2

ARC_NAME=`echo "${ARC_LINK}" | rev | cut -d'/' -f1 | rev`
echo "ARC_NAME=${ARC_NAME}"

ARC_EXT=`echo "${ARC_NAME}" | rev | cut -d'.' -f1-2 | rev`
echo "ARC_EXT=${ARC_EXT}"

if [ -f "./${ARC_NAME}" ]; then
  rm -f ${ARC_NAME}
fi

wget ${ARC_LINK}

if [ "${ARC_EXT}" = "tar.gz" ]; then
  gunzip ${ARC_NAME}
elif [ "${ARC_EXT}" = "tar.lz" ]; then
  lzip -d ${ARC_NAME}
elif [ "${ARC_EXT}" = "tar.bz2" ]; then	
  bunzip2 ${ARC_NAME}
else
  echo "Error, unrecognised archive extension!"
  exit
fi

ARC_NAME=${ARC_NAME%.*}
echo "ARC_NAME=${ARC_NAME}"
ARC_TLD=`tar tf ${ARC_NAME} | sed -e 's@/.*@@' | uniq`
echo "ARC_TLD=${ARC_TLD}"
tar -xf ${ARC_NAME}

if [ "${ARC_TLD}" != "${NAME}" ]; then
  mv ${ARC_TLD} ${NAME}
fi

rm ${ARC_NAME}
