#!/bin/bash

HOST=$1
VERSION=$2
MPI_LABEL=$3
COMPILER_LABEL=$4

LABEL=gromacs
NAME=${LABEL}-${VERSION}
ROOT=/opt/app/${LABEL}
HOST_PATH=${HOST}/${MPI_LABEL}/${COMPILER_LABEL}
SCRIPTS_ROOT=/opt/scripts/app/${LABEL}/host/${HOST_PATH}
CODE_ROOT=${ROOT}/${NAME}
BUILD_ROOT=${ROOT}/build
INSTALL_ROOT=${ROOT}/${VERSION}/${HOST_PATH}
LOG_ROOT=/opt/logs
CMAKE_PRELOAD=/lib/x86_64-linux-gnu/libssl.so.1.1:/lib/x86_64-linux-gnu/libcrypto.so.1.1


# set the build environment
. ${SCRIPTS_ROOT}/env.sh


# set make log name
mkdir -p ${LOG_ROOT}
if [ -f "${LOG_ROOT}/.make" ]; then
  makecnt=`cat ${LOG_ROOT}/.make`
  makecnt=`expr ${makecnt} + 1`
else
  makecnt="1"
fi
MAKE_LOG=${LOG_ROOT}/make.log.${makecnt}
echo "${makecnt}" > ${LOG_ROOT}/.make


# set compiler and build flags
export FLAGS="-O3 -ftree-vectorize -funroll-loops"


# build single precision
BUILD_PATH=${BUILD_ROOT}/${HOST_PATH}/single
rm -rf ${BUILD_PATH}
mkdir -p ${BUILD_PATH}
cd ${BUILD_PATH}

if [[ ${MPI_LABEL} == *"cuda"* ]]; then
  
  CMAKE_VERSION=`echo ${CMAKE_ROOT} | cut -d'-' -f2`
  CMAKE_MAJOR_VERSION=`echo ${CMAKE_VERSION} | cut -d'.' -f1-2`
  FIND_CUDA_FILE=${CMAKE_ROOT}/share/cmake-${CMAKE_MAJOR_VERSION}/Modules/FindCUDA.cmake
  UNSET_CMD="unset(CUDA_cufft_LIBRARY CACHE)"
  if [ -f ${FIND_CUDA_FILE} ]; then
    sed -i "/${UNSET_CMD}/d" ${FIND_CUDA_FILE}
  fi

  export FLAGS="${FLAGS} -I${MATHLIB}/targets/x86_64-linux/include"

  LD_PRELOAD=${CMAKE_PRELOAD} cmake ${CODE_ROOT} \
      -DGMX_MPI=ON -DGMX_OPENMP=ON -DGMX_HWLOC=OFF -DGMX_GPU=CUDA \
      -DGMX_X11=OFF -DGMX_DOUBLE=OFF -DGMX_BUILD_MDRUN_ONLY=ON -DGMX_BUILD_OWN_FFTW=ON \
      -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} \
      -DCMAKE_C_FLAGS="${FLAGS}" -DCMAKE_CXX_FLAGS="${FLAGS}" \
      -DPython3_EXECUTABLE=${MINICONDA_ROOT}/bin/python \
      -DMPI_C_HEADER_DIR="${MPI_ROOT}/include" -DMPI_CXX_HEADER_DIR="${MPI_ROOT}/include" \
      -DMPI_C_LIB_NAMES=${MPI_C_LIB} -DMPI_CXX_LIB_NAMES=${MPI_CXX_LIB} -DMPI_mpi_LIBRARY=${MPI_LIBRARY_PATH} \
      -DCUDA_TOOLKIT_ROOT_DIR=${CUDAROOT} \
      -DCUDA_cufft_LIBRARY=${MATHLIB}/targets/x86_64-linux/lib/libcufft.so \
      -DBLAS_LIBRARIES=${BLAS_LIBRARIES:-""} \
      -DLAPACK_LIBRARIES=${LAPACK_LIBRARIES:-""} \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_ROOT} &> ${MAKE_LOG}

else

  LD_PRELOAD=${CMAKE_PRELOAD} cmake ${CODE_ROOT} \
      -DGMX_MPI=ON -DGMX_OPENMP=ON -DGMX_HWLOC=OFF -DGMX_GPU=OFF \
      -DGMX_X11=OFF -DGMX_DOUBLE=OFF -DGMX_BUILD_MDRUN_ONLY=ON -DGMX_BUILD_OWN_FFTW=OFF \
      -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} \
      -DCMAKE_C_FLAGS="${FLAGS}" -DCMAKE_CXX_FLAGS="${FLAGS}" \
      -DPython3_EXECUTABLE=${MINICONDA_ROOT}/bin/python \
      -DMPI_C_HEADER_DIR="${MPI_ROOT}/include" -DMPI_CXX_HEADER_DIR="${MPI_ROOT}/include" \
      -DMPI_C_LIB_NAMES=${MPI_C_LIB} -DMPI_CXX_LIB_NAMES=${MPI_CXX_LIB} -DMPI_mpi_LIBRARY=${MPI_LIBRARY_PATH} \
      -DBLAS_LIBRARIES=${BLAS_LIBRARIES:-""} \
      -DLAPACK_LIBRARIES=${LAPACK_LIBRARIES:-""} \
      -DFFTWF_INCLUDE_DIR=${FFTW_ROOT}/include -DFFTWF_LIBRARY=${FFTW_ROOT}/lib/libfftw3f.so \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_ROOT} &> ${MAKE_LOG}

fi

LD_PRELOAD=${CMAKE_PRELOAD} make install &>> ${MAKE_LOG}


if [[ ${MPI_LABEL} != *"cuda"* ]]; then
  # build double precision
  BUILD_PATH=${BUILD_ROOT}/${HOST_PATH}/double
  rm -rf ${BUILD_PATH}
  mkdir -p ${BUILD_PATH}
  cd ${BUILD_PATH}

  LD_PRELOAD=${CMAKE_PRELOAD} cmake ${CODE_ROOT} \
      -DGMX_MPI=ON -DGMX_OPENMP=ON -DGMX_HWLOC=OFF -DGMX_GPU=OFF \
      -DGMX_X11=OFF -DGMX_DOUBLE=ON -DGMX_BUILD_MDRUN_ONLY=ON -DGMX_BUILD_OWN_FFTW=OFF \
      -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} \
      -DCMAKE_C_FLAGS="${FLAGS}" -DCMAKE_CXX_FLAGS="${FLAGS}" \
      -DPython3_EXECUTABLE=${MINICONDA_ROOT}/bin/python \
      -DMPI_C_HEADER_DIR="${MPI_ROOT}/include" -DMPI_CXX_HEADER_DIR="${MPI_ROOT}/include" \
      -DMPI_C_LIB_NAMES=${MPI_C_LIB} -DMPI_CXX_LIB_NAMES=${MPI_CXX_LIB} -DMPI_mpi_LIBRARY=${MPI_LIBRARY_PATH} \
      -DBLAS_LIBRARIES=${BLAS_LIBRARIES:-""} \
      -DLAPACK_LIBRARIES=${LAPACK_LIBRARIES:-""} \
      -DFFTW_INCLUDE_DIR=${FFTW_ROOT}/include -DFFTW_LIBRARY=${FFTW_ROOT}/lib/libfftw3.so \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_ROOT} &>> ${MAKE_LOG}

  LD_PRELOAD=${CMAKE_PRELOAD} make install &>> ${MAKE_LOG}
fi


# record
currentDateTime=`date +"%Y-%m-%d %T"`
echo "    ${currentDateTime}: Built ${LABEL} ${VERSION} (${MPI_LABEL}-${COMPILER_LABEL}) on ${HOST}" >> /.singularity.d/runscript.help
echo "                         (${MAKE_LOG})" >> /.singularity.d/runscript.help
echo "" >> /.singularity.d/runscript.help
