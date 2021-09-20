#!/bin/bash --login
  
#SBATCH -J sc_ramses
#SBATCH -o /dev/null
#SBATCH -e /dev/null
#SBATCH --time=<wall time>
#SBATCH --nodes=<node count>
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --account=<account code>
#SBATCH --partition=<partition>
#SBATCH --qos=<qos>
#SBATCH --export=none


# load module environment
module -s restore /etc/cray-pe.d/PrgEnv-gnu
module -s load openmpi/4.1.0-ofi-gcc10


# setup resource-related environment
NNODES=${SLURM_JOB_NUM_NODES}
NCORESPN=`expr ${SLURM_CPUS_ON_NODE} \/ 2`
NCORES=`expr ${NNODES} \* ${NCORESPN}`
export OMP_NUM_THREADS=1


# setup app-related environment
# <add test case specific variables here>
APP_NAME=ramses
APP_VERSION=19.10
APP_HOST=archer2
APP_MPI_LABEL=ompi4-ofi
APP_COMPILER_LABEL=gcc10
APP_EXE_NAME=${APP_NAME}3d
APP_EXE=/opt/app/${APP_NAME}/${APP_VERSION}/${APP_HOST}/${APP_MPI_LABEL}/${APP_COMPILER_LABEL}/bin/${APP_EXE_NAME}
APP_RUN_PATH=</path/to/run/dir>
APP_PARAMS=</path/to/input/namelist/file>
APP_OUTPUT=</path/to/output/file>

# setup app run directory
mkdir -p ${APP_RUN_PATH}


# todo: setup run directory contents


# setup compute nodes file
scontrol show hostnames > ${APP_RUN_PATH}/hosts
chmod a+r ${APP_RUN_PATH}/hosts


# setup singularity and container paths
SINGULARITY_PATH=/usr/bin/singularity
CONTAINER_PATH=</path/to/container/image/file>

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
echo -e "Launching ${APP_EXE_NAME} (<insert further description>) over ${NNODES} node(s) from within Singularity container(s).\n" > ${APP_OUTPUT}

mpirun -n ${NCORES} -N ${NCORESPN} -wdir ${APP_RUN_PATH} --hostfile ${APP_RUN_PATH}/hosts ${SINGULARITY_PATH} ${SINGULARITY_OPTS} ${CONTAINER_PATH} ${APP_EXE} ${APP_PARAMS} &>> ${APP_OUTPUT}

RUN_STOP=$(date +%s.%N)
RUN_TIME=$(echo "${RUN_STOP} - ${RUN_START}" | bc)
echo -e "\nmpirun time: ${RUN_TIME}" >> ${APP_OUTPUT}


# tidy up
mv ${APP_OUTPUT} ${APP_OUTPUT}${SLURM_JOB_ID}
# <insert any final clean up here>
