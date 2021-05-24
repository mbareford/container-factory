#!/bin/bash

rsync -alrvW --delete-before -e ssh $HOME/* mrb@dtn01.rdf.ac.uk:/general/z01/z01/mrb/eleanor/ubuntu
