#!/bin/bash
  
APP=$1
SIF=$2
HOST=csd3
BUILD_ARGS="${HOST} $3"
BIND_ARGS=`singularity exec ${SIF} cat /opt/scripts/app/${APP}/host/${HOST}/bindpaths.lst`

echo "Convert ${APP} container image to sandbox..."
singularity build --sandbox ${SIF}.sandbox ${SIF}
echo ""

echo "Create directories within container that match those on host..."
singularity exec --writable ${SIF}.sandbox /opt/scripts/app/${APP}/host/${HOST}/mkdirs.sh
echo ""

echo "Build ${APP} within container sandbox..."
singularity exec -B ${BIND_ARGS} --writable ${SIF}.sandbox /opt/scripts/app/${APP}/build.sh ${BUILD_ARGS}
echo ""

echo "Convert ${APP} container sandbox back to image..."
singularity build --force ${SIF} ${SIF}.sandbox
echo ""

echo "Delete ${APP} container sandbox..."
rm -rf ${SIF}.sandbox
