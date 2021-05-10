#!/bin/bash

PORT=$1
NOTEBOOK_DIR=$2
cd $NOTEBOOK_DIR

module load py-jupyter/1.0.0_py36
module load py-tensorflow/2.4.1_py36

jupyter notebook --no-browser --port=$PORT
