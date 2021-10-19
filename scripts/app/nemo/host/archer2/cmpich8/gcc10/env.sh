MPI_ROOT=/opt/cray/pe/mpich/8.1.9/ofi/gnu/9.1

HDF5_DIR=/opt/cray/pe/hdf5-parallel/1.12.0.7/gnu/9.1
NETCDF_DIR=/opt/cray/pe/netcdf-hdf5parallel/4.7.4.7/gnu/9.1
XIOS_DIR=/work/y07/shared/utils/xios/2.5/gcc/11/cmpich/8

LD_LIBRARY_PATH=${XIOS_DIR}/lib:${NETCDF_DIR}/lib:${HDF5_DIR}/lib:${MPI_ROOT}/lib:/opt/cray/pe/lib64:/opt/cray/libfabric/1.11.0.4.71/lib64:/usr/lib64/host:/usr/lib64/host/libibverbs:/lib/x86_64-linux-gnu:/.singularity.d/libs
