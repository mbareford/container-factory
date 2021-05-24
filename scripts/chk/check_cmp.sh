#!/bin/bash
  
# $1 path to installation folder
# $1 name of component 

ROOT=$1
NAME=$2

if [ -z "${ROOT}" ]; then
  echo "Missing ROOT parameter."
fi
if [ -z "${NAME}" ]; then
  echo "Missing NAME parameter."
fi

if [ ! -z "${ROOT}" ]; then
  if [ ! -d "${ROOT}" ]; then
    echo "Missing ${NAME} installation directory."
  elif [ -z "$(ls -A ${ROOT})" ]; then
    echo "Empty ${NAME} installation directory."
  else
    echo "Detected ${NAME} installation."
  fi
fi
