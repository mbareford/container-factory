MPI_ROOT=/opt/cray/pe/mpich/8.1.9/ofi/gnu/9.1
MPI_C_LIB=mpi
MPI_CXX_LIB=mpi
MPI_LIBRARY_PATH=${MPI_ROOT}/lib/libmpi.so

FFTW_ROOT=/opt/cray/pe/fftw/3.3.8.11/x86_rome

LIBSCI_ROOT=/opt/cray/pe/libsci/21.08.1.2/GNU/9.1/x86_64
BLAS_LIBRARIES=${LIBSCI_ROOT}/lib/libsci_gnu_82_mpi_mp.so
LAPACK_LIBRARIES=${BLAS_LIBRARIES}

LD_LIBRARY_PATH=${FFTW_ROOT}/lib:${LIBSCI_ROOT}/lib:${MPI_ROOT}/lib:/opt/cray/pe/lib64:/opt/cray/libfabric/1.11.0.4.71/lib64:/usr/lib64/host:/usr/lib64/host/libibverbs:/lib/x86_64-linux-gnu:/.singularity.d/libs

CC=gcc
CXX=g++
