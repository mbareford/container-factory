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

echo "Copying mellanox drivers to container sandbox..."
LIBIBVERBS_HOST_PATH=${SIF}.sandbox/lib/x86_64-linux-gnu/libibverbs-${HOST}
mkdir -p ${LIBIBVERBS_HOST_PATH}
cp /lib64/libib* ${LIBIBVERBS_HOST_PATH}/
cp /lib64/libmlx* ${LIBIBVERBS_HOST_PATH}/
cp /lib64/librdmacm* ${LIBIBVERBS_HOST_PATH}/
cp /lib64/libosm* ${LIBIBVERBS_HOST_PATH}/
cp /lib64/libnuma* ${LIBIBVERBS_HOST_PATH}/
cp /lib64/liblustreapi* ${LIBIBVERBS_HOST_PATH}/
cp /lib64/libnl-* ${LIBIBVERBS_HOST_PATH}/
cp /lib64/librxe-* ${LIBIBVERBS_HOST_PATH}/
echo ""

echo "Building ${APP} within container sandbox..."
singularity exec -B ${BIND_ARGS} --no-home --writable ${SIF}.sandbox /opt/scripts/app/${APP}/build.sh ${BUILD_ARGS}
echo ""

echo "Converting ${APP} container sandbox back to image..."
singularity build --force ${SIF} ${SIF}.sandbox
echo ""

echo "Deleting ${APP} container sandbox..."
rm -rf ${SIF}.sandbox
