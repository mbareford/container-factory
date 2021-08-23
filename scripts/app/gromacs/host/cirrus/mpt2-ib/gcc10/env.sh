MPI_ROOT=/opt/hpe/hpc/mpt/mpt-2.22
MPI_C_LIB=mpi
MPI_CXX_LIB=mpi++

FFTW_ROOT=/opt/sw/fftw/3.3.9-mpt2-gcc8

MKL_ROOT=/opt/sw/intel/compilers_and_libraries_2019.0.117/linux/mkl
BLAS_LIBRARIES=${MKL_ROOT}/lib/intel64_lin
LAPACK_LIBRARIES=${BLAS_LIBRARIES}

LD_LIBRARY_PATH=${FFTW_ROOT}/lib:${MKL_ROOT}/lib/intel64_lin:${MPI_ROOT}/lib:/opt/sw/pmi2/lib:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu/libibverbs:/.singularity.d/libs
