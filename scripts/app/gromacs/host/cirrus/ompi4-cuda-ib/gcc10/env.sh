MPI_ROOT=/lustre/sw/openmpi/4.1.0-cuda-11.2
MPI_C_LIB=mpi
MPI_CXX_LIB=mpi
MPI_LIBRARY_PATH=${MPI_ROOT}/lib/libmpi.so
PMI2_ROOT=/lustre/sw/pmi2

MKL_ROOT=/lustre/sw/intel/compilers_and_libraries_2019.0.117/linux/mkl
BLAS_LIBRARIES=${MKL_ROOT}/lib/intel64_lin
LAPACK_LIBRARIES=${BLAS_LIBRARIES}

NV_HPCSDK_ROOT=/lustre/sw/nvidia/hpcsdk-212/Linux_x86_64/21.2
NV_CUDA_ROOT=${NV_HPCSDK_ROOT}/cuda/11.2
NV_MATHLIBS_ROOT=${NV_HPCSDK_ROOT}/math_libs/11.2

CUDAROOT=${NV_CUDA_ROOT}
MATHLIB=${NV_MATHLIBS_ROOT}

LD_LIBRARY_PATH=${MKL_ROOT}/lib/intel64_lin:${MPI_ROOT}/lib:${PMI2_ROOT}/lib:${NV_CUDA_ROOT}/lib64/:${NV_MATHLIBS_ROOT}/lib64/:/lib/x86_64-linux-gnu/libibverbs-host:/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu/libibverbs:/.singularity.d/libs

CC=mpicc
CXX=mpicxx

if [[ "${PATH}" != ?(*:)"${MPI_ROOT}/bin"?(:*) ]]; then
  PATH=${MPI_ROOT}/bin:${PATH}
fi
