#!/bin/bash

# Load tools or install in your local computer
module load singularity/3.1.1

# Note: Since we cannot install portcullis V1.2.2 by conda, we dowload and used portcullis container.
# Download portcullis container. 
# The image address is different from portcullis github, because the address they provide is not existing when we download.
# singularity pull docker://maplesond/portcullis:stable

# Provide path of reference genome sequence and merged bam file.
# The merged bam file obtained from the process of braker.
# You can also provide multiple single bam files got from 01_runHisat2.sh, but it takes some time to merge bam files. It's faster to provide merged bam if you already run braker.
ref=$1
bam=$2

# Change the path of the portcullis image you've downloaded
singularity exec /path/to/portcullis_stable.sif  portcullis full --threads 16 --verbose --use_csi --output portcullis_out ${ref} ${bam}

# If you installed portcullis in your computer without using container, just do:
# portcullis full --threads 16 --verbose --use_csi --output portcullis_out $ref $bam
