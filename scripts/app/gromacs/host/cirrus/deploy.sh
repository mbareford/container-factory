#!/bin/bash

module load singularity/3.7.2

APP=$1
SIF=$2
HOST=cirrus
BUILD_ARGS="${HOST} $3"
BIND_ARGS=`singularity exec ${SIF} cat /opt/scripts/app/${APP}/host/${HOST}/bindpaths.lst`

echo "Converting ${APP} container image to sandbox..."
singularity build --sandbox ${SIF}.sandbox ${SIF}
echo ""


if [[ ${BUILD_ARGS} == *"cuda"* ]]; then
  echo "Copying mellanox drivers to container sandbox..."
  LIBIBVERBS_HOST_PATH=./${SIF}.sandbox/lib/x86_64-linux-gnu/libibverbs-host
  mkdir ${LIBIBVERBS_HOST_PATH}
  cp /lib64/libibcm* ${LIBIBVERBS_HOST_PATH}/
  cp /lib64/libibverbs* ${LIBIBVERBS_HOST_PATH}/
  cp /lib64/libmlx4* ${LIBIBVERBS_HOST_PATH}/
  cp /lib64/libmlx5* ${LIBIBVERBS_HOST_PATH}/
  cp /lib64/librdmacm* ${LIBIBVERBS_HOST_PATH}/
  echo ""
fi


echo "Building ${APP} within container sandbox..."
singularity exec -B ${BIND_ARGS} --no-home --writable ${SIF}.sandbox /opt/scripts/app/${APP}/build.sh ${BUILD_ARGS}
echo ""

echo "Converting ${APP} container sandbox back to image..."
singularity build --force ${SIF} ${SIF}.sandbox
echo ""

echo "Deleting ${APP} container sandbox..."
rm -rf ${SIF}.sandbox
