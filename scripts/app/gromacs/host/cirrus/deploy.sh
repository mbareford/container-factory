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

echo "Building ${APP} within container sandbox..."
singularity exec -B ${BIND_ARGS} --writable ${SIF}.sandbox /opt/scripts/app/${APP}/build.sh ${BUILD_ARGS}
echo ""

echo "Converting ${APP} container sandbox back to image..."
singularity build --force ${SIF} ${SIF}.sandbox
echo ""

echo "Deleting ${APP} container sandbox..."
rm -rf ${SIF}.sandbox
