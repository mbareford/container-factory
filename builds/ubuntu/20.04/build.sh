#!/bin/bash

rm -f *.sif
rm -f *.out

rm -f scripts.tar.gz
rm -rf ./scripts*


if [ -z "${1}" ]; then

  # build locally...
  mkdir -p ./scripts/aux
  cp $HOME/scripts/aux/download_src.sh ./scripts/aux/
  cp $HOME/scripts/aux/install_cmp.sh ./scripts/aux/
  cp $HOME/scripts/aux/update_env.sh ./scripts/aux/

  mkdir -p ./scripts/chk
  cp $HOME/scripts/chk/check_os.sh ./scripts/chk/
  cp $HOME/scripts/chk/check_gcc.sh ./scripts/chk/
  cp $HOME/scripts/chk/check_cmp.sh ./scripts/chk/
  cp $HOME/scripts/chk/check_ubuntu.sh ./scripts/chk/

  mkdir -p ./scripts/os
  cp $HOME/scripts/os/ubuntu-20.04.sh ./scripts/os/

  mkdir -p ./scripts/cmp
  mkdir -p ./scripts/app

  tar -czvf scripts.tar.gz ./scripts
  rm -rf scripts

  $HOME/scripts/fac/singularity/build_container.sh ubuntu20

else

  $HOME/scripts/fac/singularity/build_container_remote.sh ${1} ubuntu20

fi
