#!/bin/bash


SCRIPTS_ROOT=$1
FAC_PATH=$2
APP=$3
HOST=$4
DEPLOY_PATH=$5
DEPLOY_ARGS="${APP} ${DEPLOY_PATH}/${APP}.sif \"$6\""

DEPLOY_SCRIPT=${SCRIPTS_ROOT}/app/${APP}/host/${HOST}/deploy.sh

suffix="0"
for sif in ${APP}.sif.*; do
  sfx=`echo ${sif} | rev | cut -d. -f1 | rev`
  if [ ${sfx} -gt ${suffix} ]; then
    suffix=${sfx}
  fi
done
next_suffix=`expr ${suffix} + 1`

echo "Upload ${APP} singularity image to ${HOST} host..."
scp ${FAC_PATH}/${APP}.sif.${suffix} ${HOST}:${DEPLOY_PATH}/${APP}.sif
echo ""

echo "Run the deployment script for building the ${APP} app"
echo "within a sandboxed singularity container on the ${HOST} host..."
echo ""
ssh ${HOST} "bash -ls" < ${DEPLOY_SCRIPT} ${DEPLOY_ARGS}
echo ""

echo "Download new ${APP} singularity image from ${HOST} host..."
scp ${HOST}:${DEPLOY_PATH}/${APP}.sif ${FAC_PATH}/${APP}.sif.${next_suffix}
echo ""

echo "Delete the ${APP} singularity image left on ${HOST} host..."
ssh ${HOST} rm -f ${DEPLOY_PATH}/${APP}.sif
echo ""

echo "Targeting complete!"
echo "${FAC_PATH}/${APP}.sif.${next_suffix}"
