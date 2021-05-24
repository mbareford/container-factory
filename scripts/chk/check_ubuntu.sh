#!/bin/bash

UBUNTU_VERSION=$1

if [ "${UBUNTU_VERSION}" = "18.04" ]; then
  check_os.sh "Ubuntu 18.04 LTS"
  check_gcc.sh "7.3.0"
elif [ "${UBUNTU_VERSION}" = "19.10" ]; then
  check_os.sh "Ubuntu 19.10"
  check_gcc.sh "9.2.1"
else
  echo "Unexpected Ubuntu version, ${UBUNTU_VERSION}."
fi
