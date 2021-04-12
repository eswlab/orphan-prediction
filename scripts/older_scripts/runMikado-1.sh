#!/bin/bash
export PATH="/home/aseethar/miniconda3/bin:$PATH"
source activate mikado
list=$3
genome=$1
junctions=$2

mikado configure \
   --list $list \
   --reference $genome \
   --mode permissive \
   --scoring plants.yaml \
   --copy-scoring plants.yaml \
   --junctions $junctions configuration.yaml

mikado prepare \
   --json-conf configuration.yaml
