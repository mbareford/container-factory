#!/bin/bash

# $1 component name
# $2 path to installation folder
# $3 archive web link
# $4 configure arguments
# $5 make arguments

NAME=$1
ROOT=$2
ARC_LINK=$3
CFG_ARGS=$4
MAKE_ARG=$5

echo "NAME=${NAME}"
echo "ROOT=${ROOT}"
echo "ARC_LINK=${ARC_LINK}"
echo "CFG_ARGS=${CFG_ARGS}"
echo "MAKE_ARGS=${MAKE_ARGS}"

if [ -f "/opt/env.sh" ]; then
  . /opt/env.sh
fi

mkdir -p ${ROOT}
cd ${ROOT}

download_src.sh ${ARC_LINK} ${NAME}

cd ${NAME}

if [ -f "${CFG_ARGS}" ]; then
  cfg_args_file="${CFG_ARGS}"
  while IFS= read -r cfg_line
  do
    echo "./configure ${cfg_line} --prefix=${ROOT}"
    ./configure ${cfg_line} --prefix=${ROOT}
    make clean 
    make ${MAKE_ARGS}
    make install 
  done < "$cfg_args_file"
else
  echo "./configure ${CFG_ARGS} --prefix=${ROOT}"
  ./configure ${CFG_ARGS} --prefix=${ROOT}
  make ${MAKE_ARGS}
  make install
fi

cd ${ROOT}
rm -rf ${NAME}

if [ ! -f "${ROOT}/env.sh" ]; then
  setup_env.sh ${ROOT}
fi
