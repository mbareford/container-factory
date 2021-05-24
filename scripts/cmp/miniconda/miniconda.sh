#!/bin/bash

cd /opt
LABEL=miniconda
TYPE=$1
VERSION=$2
PY_VERSION=$3
ARCH=Linux-x86_64
NAME=${LABEL}${TYPE}-${VERSION}
WGET_NAME=Miniconda${TYPE}-py${PY_VERSION}_${VERSION}-${ARCH}
ROOT=/opt/${NAME}

if test -f "/opt/env.sh"; then
  . /opt/env.sh
fi

wget https://repo.anaconda.com/${LABEL}/${WGET_NAME}.sh
bash /opt/${WGET_NAME}.sh -b -f -p ${ROOT}
rm /opt/${WGET_NAME}.sh
cd ${ROOT}

PATH=${ROOT}/bin:$PATH
conda init --dry-run --verbose > activate.sh
conda_env_start=`grep -n "# >>> conda initialize >>>" activate.sh | cut -d':' -f 1`
conda_env_stop=`grep -n "# <<< conda initialize <<<" activate.sh | cut -d':' -f 1`

echo "sed -n '${conda_env_start},${conda_env_stop}p' activate.sh > activate2.sh" > sed.sh
echo "sed 's/^.//' activate2.sh > activate.sh" >> sed.sh
echo "rm activate2.sh" >> sed.sh
. ./sed.sh
rm ./sed.sh

. ${ROOT}/activate.sh
conda update -y -n root --all
conda deactivate


update_env.sh ${ROOT} MINICONDA_NAME ${NAME}
update_env.sh ${ROOT} MINICONDA_ROOT ${ROOT}

echo ". ${ROOT}/env.sh" >> /opt/env.sh
echo ". ${ROOT}/env.sh" >> $SINGULARITY_ENVIRONMENT
