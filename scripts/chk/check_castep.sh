#!/bin/bash

check_os.sh "Ubuntu 19.10"
check_gcc.sh "8.3"
check_cmp.sh ${HWLOC_ROOT} ${HWLOC_NAME}
check_cmp.sh ${OPENMPI_ROOT} ${OPENMPI_NAME}
check_cmp.sh ${FFTW_ROOT} ${FFTW_NAME}
check_cmp.sh ${LAPACK_ROOT} ${LAPACK_NAME}
check_cmp.sh ${MINICONDA_ROOT} ${MINICONDA_NAME}

if [ -z "${1}" ] || [ "${1}" = "factory" ]; then
  # building castep at factory
  check_cmp.sh ${CASTEP_ROOT} ${CASTEP_NAME}
fi
