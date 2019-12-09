#!/bin/bash
SRA=$1
ml sratools
prefetch \
   --max-size 100G \
   --transport ascp \
   --ascp-path "/shared/aspera/3.6.2/bin/ascp|/shared/aspera/3.6.2/etc/asperaweb_id_dsa.openssh"\
    ${SRA}
fastq-dump \
   --split-files \
  --origfmt \
  --gzip ~/ncbi/public/sra/${SRR}.sra
  
