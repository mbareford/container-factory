#!/bin/bash

check_os.sh "Ubuntu 19.10"
check_gcc.sh "9.2.1"
check_cmp.sh ${CMAKE_ROOT} ${CMAKE_NAME}
check_cmp.sh ${HWLOC_ROOT} ${HWLOC_NAME}
check_cmp.sh ${OPENMPI_ROOT} ${OPENMPI_NAME}
check_cmp.sh ${FFTW_ROOT} ${FFTW_NAME}
check_cmp.sh ${GROMACS_ROOT} ${GROMACS_NAME}
