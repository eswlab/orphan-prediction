#!/bin/bash

# Load tools or install in your local computer
module load trinity/2.6.6

# You can change threads and mem as you want. Large RNA-Seq dataset may need large memory.
THREADS=16
MEM=98G

Trinity \
   --seqType fq \
   --max_memory ${MEM} \
   --left ${1} \
   --right ${2} \
   --CPU ${THREADS} \
   --trimmomatic \
   --normalize_reads \
   --output trinity_run
