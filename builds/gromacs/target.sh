#!/bin/bash


APP=gromacs
SCRIPTS_ROOT=${HOME}/work/scripts
SCRIPTS_SNG=${SCRIPTS_ROOT}/fac/singularity


#${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} archer2 "/work/z19/z19/mrb4cab/exp" "2021.1 cmpich8-ofi gcc10"
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} archer2 "/work/z19/z19/mrb4cab/exp" "2021.1 ompi4-ofi gcc10"

#${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} csd3 "/home/dc-bare2/exp" "19.10 impi-ofi ifort2020"
#${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} csd3 "/home/dc-bare2/exp" "19.10 ompi-psm2 gcc70"

#${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} cirrus "/work/z19/z19/mrb4cab/exp" "19.10 cmpich8-ofi gcc10"
