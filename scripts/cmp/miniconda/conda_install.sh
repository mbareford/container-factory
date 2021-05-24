#!/bin/bash

if test -f "/opt/env.sh"; then
  . /opt/env.sh
fi

if [ ! -z "$MINICONDA_ROOT" ]; then

  pylibs=($(echo "${1}" | tr ',' '\n'))
  if (( "${#pylibs[@]}" > 0 )); then

    . ${MINICONDA_ROOT}/activate.sh
    
    for lib in "${pylibs[@]}"; do
      conda install -y ${lib}
    done

    conda update -y -n root --all
    conda deactivate

  fi

fi
