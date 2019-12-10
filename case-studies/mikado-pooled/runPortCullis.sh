#!/bin/bash
#pacakges needed
export PATH="/home/aseethar/miniconda3/bin:$PATH"
source activate mikado
module load perl/5.18.4-threads
module load blast/2.7.1
module load transdecoder/3.0.1
genome=TAIR10_chr_all.fas
bam="${1}"
portcullis full \
   --threads 28 \
   --verbose \
   --use_csi \
   --output portcullis_out \
   --orientation FR \
     $genome $bam
