#!/bin/bash


APP=gromacs
SCRIPTS_ROOT=${HOME}/work/scripts
SCRIPTS_SNG=${SCRIPTS_ROOT}/fac/singularity


${SCRIPTS_SNG}/target_init.sh ${SCRIPTS_ROOT} ${PWD} ${APP} archer2
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} archer2 "/work/z19/z19/mrb23cab/containers/${APP}" "2021.1 cmpich8-ofi gcc10"
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} archer2 "/work/z19/z19/mrb23cab/containers/${APP}" "2021.1 ompi4-ofi gcc10"

${SCRIPTS_SNG}/target_init.sh ${SCRIPTS_ROOT} ${PWD} ${APP} cirrus
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} cirrus "/lustre/home/z04/mrb/containers/${APP}" "2021.1 mpt2-ib gcc10"
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} cirrus "/lustre/home/z04/mrb/containers/${APP}" "2021.1 impi19-ib gcc10"
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} cirrus "/lustre/home/z04/mrb/containers/${APP}" "2021.1 ompi4-cuda-ib gcc10"
