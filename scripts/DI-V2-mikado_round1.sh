#!/bin/bash

#SBATCH -N 1
#SBATCH --ntasks-per-node=96
#SBATCH -t 96:00:00
#SBATCH -J prepare
#SBATCH -o prepare.o%j
#SBATCH -e prepare.e%j


source ~/.bashrc
source /path/to/Anaconda3/etc/profile.d/conda.sh
conda activate mikado2

mikado configure \
   --list list.txt \
   --reference Zm-B73-REFERENCE-NAM-5.0.fa \
   --mode nosplit \
   --scoring plant.yaml \
   --copy-scoring HISTORIC/plant.yaml \
   --junctions portcullis_filtered.pass.junction \
   configuration.yaml
   
# Need to revised configure.yaml manually to keeo all ORFs.
# We choose nosplit mode, and want to keep all ORFs if any ORFs overlapped.
# Add this under pick in configure.yaml
# output_format:
#    report_all_orfs: true


mikado prepare \
   --json-conf \
   configuration.yaml
