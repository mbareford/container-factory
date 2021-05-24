#!/bin/bash

VERSION=$1
LABEL=xios
NAME=${LABEL}-${VERSION}
ROOT=/opt/${LABEL}

if test -f "/opt/env.sh"; then
  . /opt/env.sh
fi

mkdir -p ${ROOT}
cd ${ROOT}

svn --non-interactive --trust-server-cert co https://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/branchs/${NAME}
cd ${NAME}

ARCH_NAME=X64_Singularity

ARCH_ENV=${ROOT}/${NAME}/arch/arch-${ARCH_NAME}.env
echo -e "export MPI_INC_DIR=\"${OPENMPI_ROOT}/include\"" > ${ARCH_ENV}
echo -e "export MPI_LIB_DIR=\"${OPENMPI_ROOT}/lib\"\n" >> ${ARCH_ENV}
echo -e "export HDF5_INC_DIR=\"${HDF5_ROOT}/include\"" >> ${ARCH_ENV}
echo -e "export HDF5_LIB_DIR=\"${HDF5_ROOT}/lib\"\n" >> ${ARCH_ENV}
echo -e "export NETCDF_INC_DIR=\"${NETCDF_ROOT}/include\"" >> ${ARCH_ENV}
echo -e "export NETCDF_LIB_DIR=\"${NETCDF_ROOT}/lib\"\n" >> ${ARCH_ENV}
echo -e "export BOOST_INC_DIR=\"\"" >> ${ARCH_ENV}
echo -e "export BOOST_LIB_DIR=\"\"\n" >> ${ARCH_ENV}
echo -e "export BLITZ_INC_DIR=\"\"" >> ${ARCH_ENV}
echo -e "export BLITZ_LIB_DIR=\"\"\n" >> ${ARCH_ENV}
echo -e "export OASIS_INC_DIR=\"\"" >> ${ARCH_ENV}
echo -e "export OASIS_LIB_DIR=\"\"" >> ${ARCH_ENV}

ARCH_PATH=${ROOT}/${NAME}/arch/arch-${ARCH_NAME}.path
echo -e "NETCDF_INCDIR=\"-I\$NETCDF_INC_DIR\"" > ${ARCH_PATH}
echo -e "NETCDF_LIBDIR=\"-L\$NETCDF_LIB_DIR\"" >> ${ARCH_PATH}
echo -e "NETCDF_LIB=\"\"\n" >> ${ARCH_PATH}
echo -e "MPI_INCDIR=\"-I\$MPI_INC_DIR\"" >> ${ARCH_PATH}
echo -e "MPI_LIBDIR=\"-L\$MPI_LIB_DIR\"" >> ${ARCH_PATH}
echo -e "MPI_LIB=\"\"\n" >> ${ARCH_PATH}
echo -e "HDF5_INCDIR=\"-I\$HDF5_INC_DIR\"" >> ${ARCH_PATH}
echo -e "HDF5_LIBDIR=\"-L\$HDF5_LIB_DIR\"" >> ${ARCH_PATH}
echo -e "HDF5_LIB=\"\"\n" >> ${ARCH_PATH}
echo -e "BOOST_INCDIR=\"\"" >> ${ARCH_PATH}
echo -e "BOOST_LIBDIR=\"\"" >> ${ARCH_PATH}
echo -e "BOOST_LIB=\"\"\n" >> ${ARCH_PATH}
echo -e "BLITZ_INCDIR=\"\"" >> ${ARCH_PATH}
echo -e "BLITZ_LIBDIR=\"\"" >> ${ARCH_PATH}
echo -e "BLITZ_LIB=\"\"\n" >> ${ARCH_PATH}
echo -e "OASIS_INCDIR=\"\"" >> ${ARCH_PATH}
echo -e "OASIS_LIBDIR=\"\"" >> ${ARCH_PATH}
echo -e "OASIS_LIB=\"\"" >> ${ARCH_PATH}

ARCH_FCM=${ROOT}/${NAME}/arch/arch-${ARCH_NAME}.fcm
echo -e "# Singularity GCC build instructions for XIOS/xios-2.5" > ${ARCH_FCM}
echo -e "" >> ${ARCH_FCM}
echo -e "%CCOMPILER      g++" >> ${ARCH_FCM}
echo -e "%FCOMPILER      gfortran" >> ${ARCH_FCM}
echo -e "%LINKER         g++\n" >> ${ARCH_FCM}
echo -e "%BASE_CFLAGS    -ansi -w" >> ${ARCH_FCM}
echo -e "%PROD_CFLAGS    -O3 -DBOOST_DISABLE_ASSERTS" >> ${ARCH_FCM}
echo -e "%DEV_CFLAGS     -g -O2" >> ${ARCH_FCM}
echo -e "%DEBUG_CFLAGS   -g\n" >> ${ARCH_FCM}
echo -e "%BASE_FFLAGS    -D__NONE__" >> ${ARCH_FCM}
echo -e "%PROD_FFLAGS    -O3" >> ${ARCH_FCM}
echo -e "%DEV_FFLAGS     -g -O2" >> ${ARCH_FCM}
echo -e "%DEBUG_FFLAGS   -g\n" >> ${ARCH_FCM}
echo -e "%BASE_INC       -D__NONE__" >> ${ARCH_FCM}
echo -e "%BASE_LD        -lstdc++\n" >> ${ARCH_FCM}
echo -e "%CPP            cpp" >> ${ARCH_FCM}
echo -e "%FPP            cpp -P" >> ${ARCH_FCM}
echo -e "%MAKE           gmake" >> ${ARCH_FCM}


MAKE_DIR=${ROOT}/${NAME}
INSTALL_DIR=${ROOT}/${VERSION}

${MAKE_DIR}/make_xios --full --arch ${ARCH_NAME}

mkdir -p ${INSTALL_DIR}
cp -r ${MAKE_DIR}/bin ${INSTALL_DIR}/
cp -r ${MAKE_DIR}/inc ${INSTALL_DIR}/
cp -r ${MAKE_DIR}/lib ${INSTALL_DIR}/

setup_env.sh $INSTALL_DIR

update_env.sh ${ROOT}/${INSTALL_DIR} XIOS_NAME ${NAME}
update_env.sh ${ROOT}/${INSTALL_DIR} XIOS_ROOT ${INSTALL_DIR}
echo ". ${ROOT}/${INSTALL_DIR}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/${INSTALL_DIR}/env.sh" >> $SINGULARITY_ENVIRONMENT
