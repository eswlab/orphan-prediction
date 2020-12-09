#!/bin/bash
export PATH="/home/aseethar/miniconda3/bin:$PATH"
source activate mikado
list=$3
genome=$1
junctions=$2
prefix=$4

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


mikado prepare \
   --json-conf configuration.yaml \
   -of ${prefix}_prepared.fasta
