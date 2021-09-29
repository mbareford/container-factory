OPENMPI_ROOT=/usr/local/Cluster-Apps/openmpi/gcc/9.3/4.0.4

export PATH=$OPENMPI_ROOT/bin:$PATH
export LD_LIBRARY_PATH=$OPENMPI_ROOT/lib:/usr/lib64/host:$LD_LIBRARY_PATH
export MPI_HOME=$OPENMPI_ROOT
export MPI_RUN=$OPENMPI_ROOT/bin/mpirun 
