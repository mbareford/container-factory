#!/bin/bash

# $1 expected gcc version

GCC_VERSION_EXP=$1
GCC_VERSION=$(gcc --version | head -n 1 | cut -d")" -f 2 | cut -d" " -f 2)

if [ "${GCC_VERSION_EXP}" != "${GCC_VERSION}" ]; then
 echo "Unexpected GCC version, ${GCC_VERSION}; should be ${GCC_VERSION_EXP}."
else
 echo "Detected GCC ${GCC_VERSION_EXP}."
fi
