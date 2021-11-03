#!/bin/bash


SCRIPTS_ROOT=$1
IMG_PATH=$2
APP=$3
HOST=$4
DEPLOY_PATH=$5
DEPLOY_ARGS="${APP} ${HOST} ${DEPLOY_PATH}/${APP}.sif \"$6\""

DEPLOY_SCRIPT=${SCRIPTS_ROOT}/app/${APP}/host/${HOST}/deploy.sh


. ${SCRIPTS_ROOT}/fac/singularity/get_latest_suffix.sh
get_latest_suffix ${IMG_PATH} ${APP}
next_suffix=`expr ${suffix} + 1`


echo "Uploading ${APP} singularity image to ${HOST} host..."
scp ${IMG_PATH}/${APP}.sif.${suffix} ${HOST}:${DEPLOY_PATH}/${APP}.sif
echo ""

echo "Running the deployment script that builds a containerized ${APP} app on the ${HOST} host..."
ssh ${HOST} "bash -ls" < ${DEPLOY_SCRIPT} ${DEPLOY_ARGS}
echo ""

echo "Downloading new ${APP} singularity image from ${HOST} host..."
scp ${HOST}:${DEPLOY_PATH}/${APP}.sif ${IMG_PATH}/${APP}.sif.${next_suffix}
echo ""

echo "Deleting the ${APP} singularity image left on ${HOST} host..."
ssh ${HOST} rm -f ${DEPLOY_PATH}/${APP}.sif
echo ""

echo "Targeting complete!"
echo "${IMG_PATH}/${APP}.sif.${next_suffix}"
