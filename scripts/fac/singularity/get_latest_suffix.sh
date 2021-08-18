#!/bin/bash

# return the latest suffix for the specified container image file
get_latest_suffix () {
  IMG_PATH=$1
  APP=$2

  suffix="0"
  for sif in ${IMG_PATH}/${APP}.sif.*; do
    sfx=`echo ${sif} | rev | cut -d. -f1 | rev`
    if [ ${sfx} -gt ${suffix} ]; then
      suffix=${sfx}
    fi
  done
}
