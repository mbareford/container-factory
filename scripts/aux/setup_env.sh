#!/bin/bash

# $1 path to installation folder

ROOT=$1

if [ -d "${ROOT}/bin" ]; then
  update_env.sh ${ROOT} PATH ${ROOT}/bin ${PATH}
fi

if [ -d "${ROOT}/include" ]; then
  update_env.sh ${ROOT} CPATH ${ROOT}/include ${CPATH}
fi

if [ -d "${ROOT}/share/man" ]; then
  update_env.sh ${ROOT} MANPATH ${ROOT}/share/man ${MANPATH}
fi

if [ -d "${ROOT}/share/aclocal" ]; then
  update_env.sh ${ROOT} ACLOCAL_PATH ${ROOT}/share/aclocal ${ACLOCAL_PATH}
fi

if [ -d "${ROOT}/lib" ]; then
  update_env.sh ${ROOT} LIBRARY_PATH ${ROOT}/lib ${LIBRARY_PATH}
  update_env.sh ${ROOT} LD_LIBRARY_PATH ${ROOT}/lib ${LD_LIBRARY_PATH}
  update_env.sh ${ROOT} LD_RUN_PATH ${ROOT}/lib ${LD_RUN_PATH}
fi

if [ -d "${ROOT}/lib64" ]; then
  update_env.sh ${ROOT} LIBRARY_PATH ${ROOT}/lib64 ${LIBRARY_PATH}
  update_env.sh ${ROOT} LD_LIBRARY_PATH ${ROOT}/lib64 ${LD_LIBRARY_PATH}
  update_env.sh ${ROOT} LD_RUN_PATH ${ROOT}/lib64 ${LD_RUN_PATH}
fi

if [ -d "${ROOT}/lib/pkgconfig" ]; then
  update_env.sh ${ROOT} PKG_CONFIG_PATH ${ROOT}/lib/pkgconfig ${PKG_CONFIG_PATH}
fi

if [ -d "${ROOT}/lib64/pkgconfig" ]; then
  update_env.sh ${ROOT} PKG_CONFIG_PATH ${ROOT}/lib64/pkgconfig ${PKG_CONFIG_PATH}
fi
