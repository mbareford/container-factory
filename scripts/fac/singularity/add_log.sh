#!/bin/bash 

SIF=$1
NAME=$2
EXT=$3

singularity build --sandbox ${SIF}.sandbox ${SIF}
singularity exec --writable ${SIF}.sandbox /opt/scripts/aux/add_log.sh /opt/logs ${NAME} ${EXT}
singularity build --force ${SIF}.new ${SIF}.sandbox

rm -rf ${SIF}.sandbox
rm -f ${SIF}
mv ${SIF}.new ${SIF}
