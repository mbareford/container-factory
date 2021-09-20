MPI_ROOT=/opt/hpe/hpc/mpt/mpt-2.22
PMI2_ROOT=/lustre/sw/pmi2

FFTW_ROOT=/lustre/sw/fftw/3.3.9-mpt2-gcc8

MKL_ROOT=/lustre/sw/intel/compilers_and_libraries_2019.0.117/linux/mkl
BLAS_LIBRARIES=${MKL_ROOT}/lib/intel64_lin
LAPACK_LIBRARIES=${BLAS_LIBRARIES}

LD_LIBRARY_PATH=${FFTW_ROOT}/lib:${MKL_ROOT}/lib/intel64_lin:${MPI_ROOT}/lib:${PMI2_ROOT}/lib:/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu/libibverbs:/.singularity.d/libs

PATH=${MPI_ROOT}/bin:${PATH}
