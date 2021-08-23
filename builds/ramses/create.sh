#!/bin/bash


echo "Deleting old images, logs and scripts..."

rm -f *.sif*
rm -f *.log
rm -rf scripts*

echo ""


echo "Gathering required scripts..."

APP=ramses
SCRIPTS_ROOT=${HOME}/work/scripts
SCRIPTS_DEF=${SCRIPTS_ROOT}/def
SCRIPTS_APP=${SCRIPTS_ROOT}/app/${APP}
SCRIPTS_SNG=${SCRIPTS_ROOT}/fac/singularity

mkdir -p ./scripts/aux
cp ${SCRIPTS_ROOT}/aux/download_src.sh ./scripts/aux/
cp ${SCRIPTS_ROOT}/aux/install_cmp.sh ./scripts/aux/
cp ${SCRIPTS_ROOT}/aux/setup_env.sh ./scripts/aux/
cp ${SCRIPTS_ROOT}/aux/update_env.sh ./scripts/aux/
cp ${SCRIPTS_ROOT}/aux/add_log.sh ./scripts/aux/
cp ${SCRIPTS_ROOT}/aux/add_dirs.sh ./scripts/aux/

mkdir -p ./scripts/chk
cp ${SCRIPTS_ROOT}/chk/check_os.sh ./scripts/chk/
cp ${SCRIPTS_ROOT}/chk/check_gcc.sh ./scripts/chk/
cp ${SCRIPTS_ROOT}/chk/check_cmp.sh ./scripts/chk/

mkdir -p ./scripts/def
cp ${SCRIPTS_ROOT}/def/ramses.def ./scripts/def/

mkdir -p ./scripts/os
cp ${SCRIPTS_ROOT}/os/ubuntu-20.04.sh ./scripts/os/

mkdir -p ./scripts/cmp
cp -r ${SCRIPTS_ROOT}/cmp/miniconda ./scripts/cmp/

mkdir -p ./scripts/app/${APP}
cp ${SCRIPTS_APP}/source.sh ./scripts/app/${APP}/
cp ${SCRIPTS_APP}/build.sh ./scripts/app/${APP}/
cp -r ${SCRIPTS_APP}/host ./scripts/app/${APP}/

tar -czf scripts.tar.gz ./scripts
rm -rf scripts

echo ""


echo "Creating ${APP} singularity image file..."

sudo singularity build ${PWD}/${APP}.sif.0 ${SCRIPTS_DEF}/${APP}.def &> create.log

echo ""


echo "Adding creation log to image file..."

${SCRIPTS_SNG}/add_log.sh ${PWD}/${APP}.sif.0 create log

echo ""


echo "Final tidy up..."

rm create.log
rm scripts.tar.gz

echo ""


echo "Creation complete!"
echo "${PWD}/${APP}.sif.0"
