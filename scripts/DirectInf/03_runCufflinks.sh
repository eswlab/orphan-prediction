#!/bin/bash

# Load tools or install in your local computer
module load cufflinks/2.2.1

# Provide the path of bam file as the first argument, and define the base name of output
bam="$1"
out=$(basename $bam |cut -f 1 -d "_")

# Run Cufflinks, you can change threads (-p) as you need. The output gtf file is in the output folder
cufflinks \
   --output-dir $out \
   --num-threads 28 \
   --verbose \
   --no-update-check \
   $bam
