#!/bin/bash

rm -f *.sif
rm -f *.out

SCRIPTS_ROOT=${HOME}/work/scripts
SCRIPTS_DEF=${SCRIPTS_ROOT}/def

sudo singularity build ${PWD}/centos7.sif ${SCRIPTS_DEF}/centos7.def
