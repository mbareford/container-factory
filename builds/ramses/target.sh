#!/bin/bash


APP=ramses
SCRIPTS_ROOT=${HOME}/work/scripts
SCRIPTS_SNG=${SCRIPTS_ROOT}/fac/singularity


#${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} archer2 "/work/z19/z19/mrb4cab/containers/build" "19.10 cmpich8-ofi gcc10"
#${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} archer2 "/work/z19/z19/mrb4cab/containers/build" "19.10 ompi4-ofi gcc10"

#${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} csd3 "/home/dc-bare2/containers/build" "19.10 impi-ofi ifort2020"
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} csd3 "/home/dc-bare2/containers/build" "19.10 ompi4-psm2 gcc9"

#${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} cirrus "/work/z19/z19/mrb4cab/exp" "19.10 cmpich8-ofi gcc10"
