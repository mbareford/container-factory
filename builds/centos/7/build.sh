#!/bin/bash

rm -f *.sif
rm -f *.out

$HOME/scripts/fac/singularity/build_container.sh centos7
