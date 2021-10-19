#!/bin/bash --login

#SBATCH -J sc_nemo
#SBATCH -o /dev/null
#SBATCH -e /dev/null
#SBATCH --time=<wall time>
#SBATCH --exclusive
#SBATCH --nodes=<node count>
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --account=<account code>
#SBATCH --partition=<partition>
#SBATCH --qos=<qos>
#SBATCH --export=none


# setup resource-related environment
NNODES=${SLURM_JOB_NUM_NODES}
NCORESPN=`expr ${SLURM_CPUS_ON_NODE} \/ 2`
NCORES=`expr ${NNODES} \* ${NCORESPN}`
export OMP_NUM_THREADS=1


# setup app-related environment
# <add test case specific variables here>
APP_NAME=nemo
APP_VERSION=4.0.6
APP_CONFIG=<config name>
APP_HOST=archer2
APP_MPI_LABEL=cmpich8
APP_COMPILER_LABEL=gcc10
APP_EXE_NAME=nemo
APP_EXE_PATH=/opt/app/${APP_NAME}/${APP_VERSION}/${APP_HOST}/${APP_MPI_LABEL}/${APP_COMPILER_LABEL}/${APP_CONFIG}
APP_RUN_PATH=</path/to/run/dir>
APP_EXE=${APP_EXE_PATH}/${APP_EXE_NAME}
APP_OUTPUT=</path/to/output/file>


# setup app run directory
mkdir -p ${APP_RUN_PATH}

# set container path
CONTAINER_PATH=${ROOT}/containers/${APP_NAME}/${APP_NAME}.sif

# setup singularity bindpaths
APP_SCRIPTS_ROOT=/opt/scripts/app/${APP_NAME}/host/${APP_HOST}
BIND_ARGS=`singularity exec ${CONTAINER_PATH} cat ${APP_SCRIPTS_ROOT}/bindpaths.lst`
BIND_ARGS=${BIND_ARGS},/var/spool/slurmd/mpi_cray_shasta,</path/to/input/data>

# setup singularity environment
singularity exec ${CONTAINER_PATH} cat ${APP_SCRIPTS_ROOT}/${APP_MPI_LABEL}/${APP_COMPILER_LABEL}/env.sh > ${APP_RUN_PATH}/env.sh

# setup input files
singularity exec ${SINGULARITY_OPTS} ${CONTAINER_PATH} /opt/scripts/app/${APP_NAME}/cfg/${APP_CONFIG}/pre_execute.sh ${APP_EXE_PATH} ${APP_RUN_PATH}

# set singularity options
SINGULARITY_OPTS="exec --bind ${BIND_ARGS} --env-file ${APP_RUN_PATH}/env.sh --home=${APP_RUN_PATH}"

# launch containerised app
RUN_START=$(date +%s.%N)
echo -e "Launching ${APP_EXE_NAME} (${APP_MPI_LABEL}-${APP_COMPILER_LABEL}) for ${APP_CONFIG} over ${NNODES} node(s) from within Singularity container(s).\n" > ${APP_OUTPUT}

srun --chdir=${APP_RUN_PATH} singularity ${SINGULARITY_OPTS} ${CONTAINER_PATH} ${APP_EXE} &>> ${APP_OUTPUT}

RUN_STOP=$(date +%s.%N)
RUN_TIME=$(echo "${RUN_STOP} - ${RUN_START}" | bc)
echo -e "\nsrun time: ${RUN_TIME}" >> ${APP_OUTPUT}


# tidy up
mv ${APP_OUTPUT} ${APP_OUTPUT}${SLURM_JOB_ID}
mv ${APP_RESULTS} ${APP_RESULTS}.o${SLURM_JOB_ID}
# <insert any final clean up here>
