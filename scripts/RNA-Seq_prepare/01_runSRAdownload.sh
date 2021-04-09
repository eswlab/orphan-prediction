#!/bin/bash

# Load tools or install in your local computer
module load sratools/2.9.6
module load ascp/3.6.2

# Define RNA-Seq SRR ID as input
SRA=$1

# Download sra file with ASCP, which should provide the path of ASCP keys
prefetch \
   # max file size is set to 100Gb
   # change `--max-size 100G` to allow >100Gb files
   --max-size 100G \
   --transport ascp \
   # provide ASCP keys. Or download without ascp if don't set --ascp-path.
   --ascp-path "/shared/aspera/3.6.2/bin/ascp|/shared/aspera/3.6.2/etc/asperaweb_id_dsa.openssh"\
    ${SRA}
    
# Convert sra file to fastq.gz files 
fastq-dump \
  --split-files \
  --origfmt \
  --gzip ~/ncbi/public/sra/${SRR}.sra
  
