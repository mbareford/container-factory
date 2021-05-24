MPI_ROOT=/work/y07/shared/libs/openmpi/4.1.0-ofi-gcc10
FFTW_ROOT=/opt/cray/pe/fftw/3.3.8.8/x86_rome
LD_LIBRARY_PATH=${FFTW_ROOT}/lib:${MPI_ROOT}/lib:/opt/cray/pe/lib64:/opt/cray/libfabric/1.11.0.0.233/lib64:/opt/cray/xpmem/2.2.35-7.0.1.0_1.9__gd50fabf.shasta/lib64:/usr/lib64/host:/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu/libibverbs:/.singularity.d/libs
