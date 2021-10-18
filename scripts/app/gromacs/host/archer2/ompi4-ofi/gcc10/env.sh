# openmpi not setup yet
MPI_ROOT=/work/y07/shared/libs/openmpi/4.1.0-ofi-gcc10
MPI_C_LIB=mpi
MPI_CXX_LIB=mpi
MPI_LIBRARY_PATH=${MPI_ROOT}/lib/libmpi.so

FFTW_ROOT=/opt/cray/pe/fftw/3.3.8.11/x86_rome

# mkl not setup yet
MKL_ROOT=/work/y07/shared/libs/mkl/mkl-2021.2-2883/mkl/2021.2.0
BLAS_LIBRARIES=${MKL_ROOT}/lib/intel64
LAPACK_LIBRARIES=${BLAS_LIBRARIES}

LD_LIBRARY_PATH=${FFTW_ROOT}/lib:${MKL_ROOT}/lib/intel64:${MPI_ROOT}/lib:/opt/cray/pe/lib64:/opt/cray/libfabric/1.11.0.4.71/lib64:/opt/cray/xpmem/2.2.40-7.0.1.0_2.7__g1d7a24d.shasta/lib64:/usr/lib64/host:/usr/lib64/host/libibverbs:/lib/x86_64-linux-gnu:/.singularity.d/libs

CC=gcc
CXX=g++

if [[ "${PATH}" != ?(*:)"${MPI_ROOT}/bin"?(:*) ]]; then
  PATH=${MPI_ROOT}/bin:${PATH}
fi
