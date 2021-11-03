export MPI_DIR=/opt/cray/pe/mpich/8.1.3/ofi/gnu/9.1

export HDF5_DIR=/opt/cray/pe/hdf5-parallel/1.12.0.3/gnu/9.1
export NETCDF_DIR=/opt/cray/pe/netcdf-hdf5parallel/4.7.4.3/gnu/9.1
export XIOS_DIR=/opt/cmp/xios/2.5/archer2/cmpich8/gcc10

export LD_LIBRARY_PATH=${XIOS_DIR}/lib:${NETCDF_DIR}/lib:${HDF5_DIR}/lib:${MPI_DIR}/lib:/opt/cray/pe/lib64:/opt/cray/libfabric/1.11.0.0.233/lib64:/usr/lib64/host:/usr/lib64/host/libibverbs:/lib/x86_64-linux-gnu:/.singularity.d/libs
