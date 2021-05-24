#!/bin/bash

SCRIPTS_PATH=${1}
cp ${SCRIPTS_PATH}/post_start.sh /opt/
cp ${SCRIPTS_PATH}/post_stop.sh /opt/

mkdir -p /opt/scripts/aux
cp ${SCRIPTS_PATH}/aux/install_cmp.sh /opt/scripts/aux/
cp ${SCRIPTS_PATH}/aux/update_env.sh /opt/scripts/aux/
cp ${SCRIPTS_PATH}/aux/check_os.sh /opt/scripts/aux/
cp ${SCRIPTS_PATH}/aux/check_gcc.sh /opt/scripts/aux/
cp ${SCRIPTS_PATH}/aux/check_cmp.sh /opt/scripts/aux/
cp ${SCRIPTS_PATH}/aux/check_ubuntu.sh /opt/scripts/aux/

mkdir -p /opt/scripts/os
cp ${SCRIPTS_PATH}/os/ubuntu-19.10.sh /opt/scripts/os/

mkdir -p /opt/scripts/cmp
mkdir -p /opt/scripts/app

chmod -R a+rx /opt/scripts
