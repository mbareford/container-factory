#!/bin/bash 

SIF=$1
APP=$2
HOST=$3

singularity build --sandbox ${SIF}.sandbox ${SIF}
singularity exec --writable ${SIF}.sandbox /opt/scripts/aux/add_dirs.sh ${APP} ${HOST}
singularity build --force ${SIF} ${SIF}.sandbox

rm -rf ${SIF}.sandbox
