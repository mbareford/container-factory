#!/bin/bash

# $1 name of application (e.g., arepo, ramses, sphng)
# $2 name of test (e.g., Illustris3, cosmo3d, cloud)
# $3 type of test (e.g., single [node], strong [scaling], weak [scaling])
# $4 number of compute nodes
# $5 number of cores per compute node
# $6 number of mpi processes
# $7 name of parameters file

# ./run_app.sh arepo Illustris3 strong 1 36 36 param_1024.txt
# ./run_app.sh ramses cosmo3d strong 1 36 36 params_256.nml
# ./run_app.sh sphng cloud strong 1 36 12 setup_2e5.txt

APP=$1
TEST_NAME=$2
TEST_TYPE=$3
NNODES=$4
NCORES_PER_NODE=$5
NTASKS=$6
PARAMS=$7

ROOT=$HOME/containers/dirac/$APP

cp /opt/app/$APP/submit.sh $ROOT/$TEST_NAME/

$ROOT/$TEST_NAME/submit.sh $ROOT $TEST_NAME $TEST_TYPE $NNODES $NCORES_PER_NODE $NTASKS $PARAMS
