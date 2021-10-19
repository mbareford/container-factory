#!/bin/bash
  
REF_PATH=$1

sed -i 's/key_top/key_nosignedzero/g' ${REF_PATH}/cpp_GYRE_PISCES.fcm
