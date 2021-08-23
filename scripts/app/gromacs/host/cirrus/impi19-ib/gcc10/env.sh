MPI_ROOT=/opt/sw/intel/compilers_and_libraries_2019.0.117/linux/mpi/intel64
MPI_C_LIB=mpicxx
MPI_CXX_LIB=mpicxx

FFTW_ROOT=/opt/sw/fftw/3.3.9-mpt2-gcc8

MKL_ROOT=/opt/sw/intel/compilers_and_libraries_2019.0.117/linux/mkl
BLAS_LIBRARIES=${MKL_ROOT}/lib/intel64_lin
LAPACK_LIBRARIES=${BLAS_LIBRARIES}

LD_LIBRARY_PATH=${FFTW_ROOT}/lib:${MKL_ROOT}/lib/intel64_lin:${MPI_ROOT}/lib:${MPI_ROOT}/lib/release:${MPI_ROOT}/libfabric/lib:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu/libibverbs:/.singularity.d/libs
