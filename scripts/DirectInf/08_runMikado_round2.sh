#!/bin/bash

# Load tools or install in your local computer
# Mikado 2.0
source activate mikado

# Setup variables
orfs=$1
prefix=$2

# Serialise
mikado serialise \
   --start-method spawn \
   --procs 28 \
   --json-conf configuration.yaml \
   --orfs ${orfs} \
   -mr 1
   
# Pick
# The final gene model is ${prefix}.loci.gff3
mikado pick \
   --loci_out ${prefix}.loci.gff3
   --start-method spawn \
   --procs 28 \
   --json-conf configuration.yaml \
   --subloci_out ${prefix}.subloci.gff3 \
   --pad
