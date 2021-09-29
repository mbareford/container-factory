MPI_ROOT=/opt/cray/pe/mpich/8.1.3/ofi/gnu/9.1

FFTW_ROOT=/opt/cray/pe/fftw/3.3.8.9/x86_rome

LIBSCI_ROOT=/opt/cray/pe/libsci/21.03.1.1/GNU/9.1/x86_64

LD_LIBRARY_PATH=${FFTW_ROOT}/lib:${LIBSCI_ROOT}/lib:${MPI_ROOT}/lib:/opt/cray/pe/lib64:/opt/cray/libfabric/1.11.0.0.233/lib64:/usr/lib64/host:/usr/lib64/host/libibverbs:/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu/libibverbs:/.singularity.d/libs
