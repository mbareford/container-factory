#!/bin/bash --login

#SBATCH -J sc_castep
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
APP_NAME=castep
APP_VERSION=20.1.1
APP_HOST=archer2
APP_MPI_LABEL=cmpich8-ofi
APP_COMPILER_LABEL=gfortran9
APP_EXE_NAME=${APP_NAME}.mpi
APP_EXE=/opt/app/${APP_NAME}/${APP_VERSION}/${APP_HOST}/${APP_MPI_LABEL}/${APP_COMPILER_LABEL}/bin/${APP_EXE_NAME}
APP_RUN_PATH=</path/to/run/dir>
APP_PARAMS=</path/to/input/namelist/file>
APP_OUTPUT=</path/to/output/file>

# setup app run directory
mkdir -p ${APP_RUN_PATH}

# setup compute nodes file
scontrol show hostnames > ${APP_RUN_PATH}/hosts
chmod a+r ${APP_RUN_PATH}/hosts

# setup singularity and container paths
SINGULARITY_PATH=/usr/bin/singularity
CONTAINER_PATH=${ROOT}/containers/${APP_NAME}/${APP_NAME}.sif

# setup singularity bindpaths
APP_SCRIPTS_ROOT=/opt/scripts/app/${APP_NAME}/host/${APP_HOST}
BIND_ARGS=`singularity exec ${CONTAINER_PATH} cat ${APP_SCRIPTS_ROOT}/bindpaths.lst`
BIND_ARGS=${BIND_ARGS},/var/spool/slurmd/mpi_cray_shasta,</path/to/input/data>
SINGULARITY_OPTS="exec --bind ${BIND_ARGS}"

# setup singularity environment
singularity exec ${CONTAINER_PATH} cat ${APP_SCRIPTS_ROOT}/${APP_MPI_LABEL}/${APP_COMPILER_LABEL}/env.sh > ${APP_RUN_PATH}/env.sh
sed -i -e 's/LD_LIBRARY_PATH/export SINGULARITYENV_LD_LIBRARY_PATH/g' ${APP_RUN_PATH}/env.sh
. ${APP_RUN_PATH}/env.sh


# launch containerised app
RUN_START=$(date +%s.%N)
echo -e "Launching ${APP_EXE_NAME} (${APP_MPI_LABEL}-${APP_COMPILER_LABEL}) ${CASE} ${SIZE} (${TEST}) over ${NNODES} node(s) from within Singularity container(s).\n" > ${APP_OUTPUT}

srun --distribution=block:block --hint=nomultithread --chdir=${APP_RUN_PATH} ${SINGULARITY_PATH} ${SINGULARITY_OPTS} ${CONTAINER_PATH} ${APP_EXE} ${APP_PARAMS} &>> ${APP_OUTPUT}

RUN_STOP=$(date +%s.%N)
RUN_TIME=$(echo "${RUN_STOP} - ${RUN_START}" | bc)
echo -e "\nsrun time: ${RUN_TIME}" >> ${APP_OUTPUT}


# tidy up
mv ${APP_OUTPUT} ${APP_OUTPUT}${SLURM_JOB_ID}
mv ${APP_RESULTS} ${APP_RESULTS}.o${SLURM_JOB_ID}
# <insert any final clean up here>
