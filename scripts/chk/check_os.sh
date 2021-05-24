#!/bin/bash
  
# $1 expected os name

OS_NAME_EXP=$1
OS_NAME=$(grep -n "PRETTY_NAME=" /etc/os-release | cut -d"=" -f 2 | cut -d "\"" -f 2)

if [ "${OS_NAME_EXP}" != "${OS_NAME}" ]; then
  echo "Unexpected OS, ${OS_NAME}; should be ${OS_NAME_EXP}."
else
  echo "Detected OS ${OS_NAME_EXP}."
fi
