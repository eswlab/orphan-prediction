#!/bin/bash

# Load tools or install in your local computer
module load stringtie/1.3.3

# Provide the path of bam file as the first argument, and define the base name of output
bam="$1"
out=$(basename $bam |cut -f 1 -d "_")

# Run Cufflinks, you can change threads (-p) as you need.
stringtie \
   ${bam} \
   -p 28 \
   -v \
   -o ${out}_cufflinks.gtf
