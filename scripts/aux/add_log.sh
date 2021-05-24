#!/bin/bash

# $1 path to container log folder
# $2 log name 
# $3 log file extension

ROOT=$1
NAME=$2
EXT=$3

mkdir -p ${ROOT}

if [ -f "${ROOT}/.${NAME}" ]; then
  cnt=`cat ${ROOT}/.${NAME}`
  cnt=`expr ${cnt} + 1`
else
  cnt="0"
fi

cp ./${NAME}.${EXT} ${ROOT}/${NAME}.${EXT}.${cnt}

echo "${cnt}" > ${ROOT}/.${NAME}
