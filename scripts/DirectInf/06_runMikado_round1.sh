#!/bin/bash

# Load tools or install in your local computer
# Mikado 2.0
source activate mikado

genome=$1
junctions=$2
list=$3
prefix=$4

# Generate configuration file
mikado configure \
   --list $list \
   --reference $genome \
   --mode nosplit \
   --scoring plant.yaml \
   --copy-scoring plant.yaml \
   --junctions $junctions configuration.yaml

# Need to revised configure.yaml manually to keep all ORFs.
# We choose nosplit mode, and want to keep all ORFs if any ORFs overlapped.
# Add this under pick in configure.yaml
# output_format:
#    report_all_orfs: true

# Prepare transcirpts fasta
mikado prepare \
   --json-conf configuration.yaml \
   -of ${prefix}_prepared.fasta
