#!/bin/bash
  
CONTAINER_PATH=$1
HOST_PATH=$2

cp ${CONTAINER_PATH}/* ${HOST_PATH}/
