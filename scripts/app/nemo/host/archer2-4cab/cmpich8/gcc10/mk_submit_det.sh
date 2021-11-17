#!/bin/ksh
#
# ./mk_submit_det.sh -S 64 -s 16 -m 2 -C 1536 -c 2 > sc_det_gcc10_cmpich8_ofi_n32.ll

# set some defaults
NSE=4
NS_SP=8
NS_PN=2
NCL=28
NC_SP=2
TIM=02:00:00
NAM=nemo
ACCT=z19
#
# Allow command-line arguments to override defaults
#
while getopts ":S:s:m:C:c:a:t:j:" opt; do
 case $opt in
   S ) NSE=$OPTARG
;;
   s ) NS_SP=$OPTARG
;;
   m ) NS_PN=$OPTARG
;;
   C ) NCL=$OPTARG
;;
   c ) NC_SP=$OPTARG
;;
   t ) TIM=$OPTARG
;;
   a ) ACCT=$OPTARG
;;
   j ) NAM=$OPTARG
;;
 \? ) print 'usage: mk_submit_det.sh [-S num_servers] [-s server_spacing] [-m max_servers_per_node] [-C num_clients] [-c client_spacing][-t time_limit] [-a account] [-j job_name]' >&2
      return 1
 esac
done
shift $(($OPTIND - 1))
echo "Running: mk_submit_det.sh -S "$NSE" -s "$NS_SP" -m " $NS_PN" -C " $NCL" -c " $NC_SP" -t "$TIM" -a "$ACCT" -j "$NAM >&2
nservers=$NSE
ns_sparsity=$NS_SP
max_servers_per_node=$NS_PN
#
nclients=$NCL
nc_sparsity=$NC_SP
#
EXEC1=/opt/cmp/xios/2.5/archer2-4cab/cmpich8/gcc10/bin/xios_server.exe
EXEC2=/opt/app/nemo/4.0.6/archer2-4cab/cmpich8/gcc10/cfgs/GYRE_PISCES_CFG/BLD/bin/nemo.exe
set -A map $EXEC1 $EXEC2
#
let cores_used=nservers+nclients
let reserved_cores_needed=nservers*ns_sparsity+nclients*nc_sparsity
let nodes_needed=reserved_cores_needed/128
let reserved_cores=nodes_needed*128
if test $reserved_cores -lt $reserved_cores_needed ; then
  let nodes_needed=nodes_needed+1
  let reserved_cores=nodes_needed*128
fi
echo "nodes needed= "$nodes_needed" ("$reserved_cores")" >&2
echo "cores to be used= "$cores_used" ("$reserved_cores_needed")" >&2
i=0
nserv=0
totnserv=0
cpu=0
while test $i -lt $cores_used
do
  if test $nserv -lt $max_servers_per_node && test $totnserv -lt $nservers ; then
    ex[i]=0
    let pl[i]=cpu
    let cpu=cpu+ns_sparsity
    let nserv=nserv+1
    let totnserv=totnserv+1
  else
    ex[i]=1
    let pl[i]=cpu
    let cpu=cpu+nc_sparsity
  fi
  if test $cpu -gt 127 ; then
   nserv=0
   let cpu=cpu%128
  fi
  let i=i+1
done
#
index=0
bstr="--cpu-bind=v,map_cpu:"
while test $index -lt $cores_used
do
  #echo -n exec ${map[${ex[$index]}]} " : " ; printf "%2.2d %#02x %d\n" $index ${pl[$index]} ${pl[$index]}
  c=$(printf "%#02x," ${pl[$index]})
  bstr=$bstr$c
  let index=index+1
done
##
# Construct slurm script:
cat << EOFA
#!/bin/bash

#SBATCH --job-name=sc_$NAM
#SBATCH -o /dev/null
#SBATCH -e /dev/null
#SBATCH --time=$TIM
#SBATCH --exclusive
#SBATCH --nodes=$nodes_needed
#SBATCH --ntasks=$cores_used
#SBATCH --account=$ACCT
#SBATCH --partition=standard
#SBATCH --qos=standard


# Created by: mk_submit_det.sh -S $NSE -s $NS_SP -m $NS_PN -C  $NCL -c  $NC_SP -t $TIM -a $ACCT -j $NAM


module -s restore /etc/cray-pe.d/PrgEnv-gnu
module -s load cray-hdf5-parallel
module -s load cray-netcdf-hdf5parallel
module -s load cpe/21.03
module -s unload cpe/21.03
module -s swap gcc gcc/10.2.0

#module -s swap craype-network-ofi craype-network-ucx
#module -s swap cray-mpich cray-mpich-ucx
#module -s load libfabric

export LD_LIBRARY_PATH=\${CRAY_LD_LIBRARY_PATH}:\${LD_LIBRARY_PATH}


# setup resource-related environment
NNODES=\${SLURM_JOB_NUM_NODES}
NCORESPN=\`expr \${SLURM_CPUS_ON_NODE} \/ 2\`
NCORES=\`expr \${NNODES} \* \${NCORESPN}\`
export OMP_NUM_THREADS=1


# setup app-related environment
CASE=GYRE_PISCES_CFG
TEST=strong
HOST=archer2-4cab
ROOT=/work/z19/z19/mrb4cab
APP_NAME=nemo
APP_VERSION=4.0.6
APP_EXE_NAME=nemo.exe
APP_MPI_LABEL=cmpich8
APP_COMMS_LABEL=ofi
APP_COMPILER_LABEL=gcc10
APP_XIOS_MODE=detached
APP_RUN_ROOT=\${ROOT}/tests/\${APP_NAME}
APP_RUN_PATH=\${APP_RUN_ROOT}/\${CASE}/results/\${TEST}/sc/\${APP_XIOS_MODE}/\${APP_COMPILER_LABEL}/\${APP_MPI_LABEL}-\${APP_COMMS_LABEL}/n\${NNODES}
APP_OUTPUT=\${APP_RUN_PATH}/\${APP_NAME}.o

# setup app run directory
mkdir -p \${APP_RUN_PATH}

# set container path
CONTAINER_PATH=\${ROOT}/containers/\${APP_NAME}/\${APP_NAME}.sif

# setup singularity bindpaths
APP_SCRIPTS_ROOT=/opt/scripts/app/\${APP_NAME}/host/\${APP_HOST}
BIND_ARGS=\`singularity exec \${CONTAINER_PATH} cat \${APP_SCRIPTS_ROOT}/bindpaths.lst\`
BIND_ARGS=\${BIND_ARGS},/var/spool/slurmd/mpi_cray_shasta,\${APP_RUN_ROOT}

# setup singularity environment
singularity exec \${CONTAINER_PATH} cat \${APP_SCRIPTS_ROOT}/\${APP_MPI_LABEL}/\${APP_COMPILER_LABEL}/env.sh > \${APP_RUN_PATH}/env.sh
sed -i -e 's/LD_LIBRARY_PATH/SINGULARITYENV_LD_LIBRARY_PATH/g' \${APP_RUN_PATH}/env.sh
. \${APP_RUN_PATH}/env.sh

# setup input files
APP_INPUT_PATH=/opt/scripts/app/\${APP_NAME}/\${APP_VERSION}/\${HOST}/\${APP_MPI_LABEL}/\${APP_COMPILER_LABEL}/\${CASE}
singularity exec \${SINGULARITY_OPTS} \${CONTAINER_PATH} /opt/scripts/app/\${APP_NAME}/cfg/\${APP_CONFIG}/pre_execute.sh \${APP_INPUT_PATH} \${APP_RUN_PATH}

# set singularity options
SINGULARITY_OPTS="exec --bind \${BIND_ARGS}"

# run app
RUN_START=\$(date +%s.%N)
echo -e "Launching \${APP_EXE_NAME} in detached mode (\${APP_MPI_LABEL}-\${APP_COMPILER_LABEL}) \${CASE} (\${TEST}) over \${NNODES} node(s).\n" > \${APP_OUTPUT}

#
cat > \${APP_RUN_PATH}/myscript_wrapper2.sh << EOFB
#!/bin/ksh
#
set -A map $EXEC1 $EXEC2
exec_map=( ${ex[@]} )
#
exec \\\${map[\\\${exec_map[\\\$SLURM_PROCID]}]}
##
EOFB
chmod u+x \${APP_RUN_PATH}/myscript_wrapper2.sh
#
srun --mem-bind=local $bstr --chdir=\${APP_RUN_PATH} singularity \${SINGULARITY_OPTS} \${CONTAINER_PATH} \${APP_RUN_PATH}/myscript_wrapper2.sh &>> \${APP_OUTPUT}

RUN_STOP=\$(date +%s.%N)
RUN_TIME=\$(echo "\${RUN_STOP} - \${RUN_START}" | bc)
echo -e "\nsrun time: \${RUN_TIME}" >> \${APP_OUTPUT}


# tidy up
mv \${APP_OUTPUT} \${APP_OUTPUT}\${SLURM_JOB_ID}
mv \${APP_RUN_PATH}/ocean.output \${APP_RUN_PATH}/ocean.o\${SLURM_JOB_ID}
. \${APP_RUN_ROOT}/\${CASE}/scripts/clean \${APP_RUN_PATH}
EOFA
