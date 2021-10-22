#!/bin/bash


APP=nemo
SCRIPTS_ROOT=${HOME}/work/scripts
SCRIPTS_SNG=${SCRIPTS_ROOT}/fac/singularity


${SCRIPTS_SNG}/target_init.sh ${SCRIPTS_ROOT} ${PWD} ${APP} archer2
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} archer2 "/work/z19/z19/mrb23cab/containers/${APP}" "2.5 4.0.6 GYRE_PISCES GYRE_PISCES_CFG cmpich8 gcc10"

${SCRIPTS_SNG}/target_init.sh ${SCRIPTS_ROOT} ${PWD} ${APP} cirrus
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} cirrus "/lustre/home/z04/mrb/containers/${APP}" "2.5 4.0.6 GYRE_PISCES GYRE_PISCES_CFG mpt2-ib gcc10"
