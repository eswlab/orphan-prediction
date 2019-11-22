#!/bin/bash
module purge
source ~/.bashrc
source activate
ref=/work/GIF/arnstrm/GENOMEDB/TAIR10_chr_all.fas
bam=/work/LAS/mash-lab/arnstrm/20180727_Mikado/01_alignment/merged_better_and_best.bam
portcullis full --threads 16 --verbose --use_csi --output portcullis_out --orientation FR $ref $bam
