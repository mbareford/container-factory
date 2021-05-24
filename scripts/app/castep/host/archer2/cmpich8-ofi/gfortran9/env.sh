MPI_ROOT=/opt/cray/pe/mpich/8.0.16/ofi/gnu/9.1
LIBSCI_ROOT=/opt/cray/pe/libsci/20.10.1.2/GNU/9.1/x86_64
FFTW_ROOT=/opt/cray/pe/fftw/3.3.8.8/x86_rome
LD_LIBRARY_PATH=${FFTW_ROOT}/lib:${LIBSCI_ROOT}/lib:${MPI_ROOT}/lib:/opt/cray/pe/lib64:/opt/cray/libfabric/1.11.0.0.233/lib64:/usr/lib64/host:/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu/libibverbs:/.singularity.d/libs
