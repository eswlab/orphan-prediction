#!/bin/bash

# Set up your local augustus config folder for the containder
singularity exec ${SINGULARITY_IMAGE} cp -R /usr/local/config augustus_config

readonly GENOME=$1
readonly bam=$2
readonly SINGULARITY_IMAGE=/path/to/braker2.sif
readonly key=/path/to/gm_key

BASE=$(basename ${GENOME%.*})

# Species name should be unique in the augustus/config/species/, you can change it to what you want
env time -v singularity run \
    --no-home \
    --home ${key} \
    --cleanenv \
    --env AUGUSTUS_CONFIG_PATH=${PWD}/augustus_config \
    ${SINGULARITY_IMAGE} braker.pl \
       --cores=16 \
       --overwrite \
       --species=${BASE} \
       --genome=${GENOME} \
       --bam=${bam} \
       --gff3
