#!/bin/bash

# Install CLASS-2.1.7 and export the bin directory

# Provide the path of bam file as the first argument, and define the base name of output
bam=$1
out=$(basename $bam |cut -f 1 -d "_")

# Run Class2, you can change threads (-p) as you need.
run_class.pl \
   -a $bam \
   -o ${out}_class.gtf \
   -p 28 \
   --verbose \
   --clean
