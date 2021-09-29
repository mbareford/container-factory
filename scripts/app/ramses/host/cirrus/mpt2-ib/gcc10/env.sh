MPI_ROOT=/opt/hpe/hpc/mpt/mpt-2.22
PMI2_ROOT=/lustre/sw/pmi2

LD_LIBRARY_PATH=${MPI_ROOT}/lib:${PMI2_ROOT}/lib:/lib/x86_64-linux-gnu/libibverbs-host:/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu/libibverbs:/.singularity.d/libs

if [[ "${PATH}" != ?(*:)"${MPI_ROOT}/bin"?(:*) ]]; then
  PATH=${MPI_ROOT}/bin:${PATH}
fi
