#!/bin/bash


APP=ramses
SCRIPTS_ROOT=${HOME}/work/scripts
SCRIPTS_SNG=${SCRIPTS_ROOT}/fac/singularity


${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} archer2 "/work/z19/z19/mrb4cab/containers/${APP}" "19.10 cmpich8-ofi gcc10"
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} archer2 "/work/z19/z19/mrb4cab/containers/${APP}" "19.10 ompi4-ofi gcc10"

${SCRIPTS_SNG}/target_init.sh ${SCRIPTS_ROOT} ${PWD} ${APP} csd3
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} csd3 "/home/dc-bare2/containers/${APP}" "19.10 impi-ofi ifort2020"
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} csd3 "/home/dc-bare2/containers/${APP}" "19.10 ompi4-psm2 gcc9"

${SCRIPTS_SNG}/target_init.sh ${SCRIPTS_ROOT} ${PWD} ${APP} cirrus
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} cirrus "/lustre/home/z04/mrb/containers/${APP}" "19.10 mpt2-ib gcc10"
${SCRIPTS_SNG}/target.sh ${SCRIPTS_ROOT} ${PWD} ${APP} cirrus "/lustre/home/z04/mrb/containers/${APP}" "19.10 impi19-ib gcc10"
