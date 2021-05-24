#!/bin/bash

# $1 path to installation folder
# $2 name of environment variable
# $3 value of environment variable
# $4 current value

ROOT=$1
NAME=$2
VALUE=$3
EXISTING_VALUE=$4

ENV=${ROOT}/env.sh

EXPORT_CMD="export ${NAME}=${VALUE}"
if [ -n "${EXISTING_VALUE}" ]; then
  EXPORT_CMD=${EXPORT_CMD}:\$${NAME}
fi

if test -f "${ENV}"; then
  echo "${EXPORT_CMD}" >> ${ENV}
else
  echo "${EXPORT_CMD}" > ${ENV}
fi
