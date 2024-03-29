#!/bin/bash

# Usage

# 1. Default Jupyter notebook (with your scratch to work in)
# $ bash start.sh singularity-jupyter

# 2. Default Jupyter notebook with custom working directory
# $ bash start.sh singularity-jupyter /scratch/users/<username>

# 3. Select your own jupyter container on Sherlock!
# $ bash start.sh singularity-jupyter /scratch/users/<username> /path/to/container

# 4. Or any singularity container...
# $ bash start.sh singularity /path/to/container <args>

PORT=$1
NOTEBOOK_DIR=${2:-${SCRATCH}}
CONTAINER=${3:-/scratch/users/vsochat/share/repo2docker.simg}

export SINGULARITY_CACHEDIR="${SCRATCH}/.singularity"
echo "Container is ${CONTAINER}"
echo "Notebook directory is ${NOTEBOOK_DIR}"
cd ${NOTEBOOK_DIR}

# Create .local folder for default modules, if doesn't exist
if [ ! -d "${HOME}/.local" ]; then
    echo "Creating local python modules folder to map at ${HOME}/.local";
    mkdir -p "${HOME}/.local";
fi

# If the container is from Docker Hub, pull it first
if [[ "${CONTAINER}" == docker* ]]; then
    singularity pull --name $(basename ${CONTAINER}).sif "${CONTAINER}"
    CONTAINER=$(basename ${CONTAINER}).sif
fi
# echo "singularity exec --home ${HOME} --bind ${HOME}/.local:/home/username/.local ${CONTAINER} jupyter notebook --no-browser --port=$PORT --ip 0.0.0.0"
singularity exec --nv --home ${HOME} --bind ${HOME}/.local:/home/username/.local ${CONTAINER} jupyter notebook --no-browser --port=$PORT --ip 0.0.0.0
