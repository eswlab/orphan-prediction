#!/bin/bash

# Load tools or install in your local computer
module load braker/2.1.2

# Download genemark key (http://topaz.gatech.edu/GeneMark/license_download.cgi) and put it in your local computer as .gm_key
# cp gm_key_64 ~/.gm_key

# Export editable augustus path
export AUGUSTUS_CONFIG_PATH=/path/to/augustus/config
export AUGUSTUS_BIN_PATH=/path/to/bin/augustus/bin
export AUGUSTUS_SCRIPTS_PATH=/path/to/augustus/scripts

GENOME=$1
bam=$2
BASE=$(basename ${GENOME%.*})

# Species name should be unique in the augustus/config/species/, you can change it to what you want
braker.pl --cores=16 --overwrite --species=${BASE} --genome=${GENOME} --bam=${bam} --gff3
