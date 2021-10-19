#!/bin/bash

EXP00_PATH=$1
SHARED_PATH=$2

sed -i '/using_server/s/false/true/' ${EXP00_PATH}/iodef.xml
sed -i '/ln_bench/s/false/true/' ${EXP00_PATH}/namelist_cfg

rm -f ${EXP00_PATH}/time.step
rm -f ${EXP00_PATH}/solver.stat
rm -f ${EXP00_PATH}/output.namelist.dyn
rm -f ${EXP00_PATH}/ocean.output
rm -f ${EXP00_PATH}/slurm-*
rm -f ${EXP00_PATH}/GYRE_*

sed -i -r -e 's/^( *nn_itend *=).*/\1 101/' \
    -e 's/^( *nn_write *=).*/\1 4320/' \
    -e 's/^( *nn_GYRE *=).*/\1 192/' \
    -e 's/^( *rn_rdt *=).*/\1 1200/' \
    ${EXP00_PATH}/namelist_cfg


replace_link () {
  rm ${EXP00_PATH}/${1}
  cp ${SHARED_PATH}/${1} ${EXP00_PATH}/
}

replace_link("axis_def_nemo.xml")
replace_link("domain_def_nemo.xml")
replace_link("field_def_nemo-oce.xml")
replace_link("field_def_nemo-pisces.xml")
replace_link("grid_def_nemo.xml")
replace_link("namelist_pisces_ref")
replace_link("namelist_ref")
replace_link("namelist_top_ref")
