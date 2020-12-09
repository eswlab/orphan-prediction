#!/bin/bash
#pacakges needed
export PATH="/home/aseethar/miniconda3/bin:$PATH"
source activate mikado

#setup variables
orfs=$1
prefix=$2

#serialise
mikado serialise \
   --start-method spawn \
   --procs 28 \
   --json-conf configuration.yaml \
   --orfs ${orfs} \
   -mr 1
#pick
mikado pick \
   --loci_out ${prefix}.loci.gff3
   --start-method spawn \
   --procs 28 \
   --json-conf configuration.yaml \
   --subloci_out ${prefix}.subloci.gff3 \
   --pad
