#!/bin/bash
# works on L3
# change this to condo is you need to run it there
# needs rnaseq reads as well as the genome to be annotated
# if you have multiple RNA seq libraries merge them together (all R1's and all R2's seperately)
#if [ $# -lt 3 ] ; then
#       echo "usage: runBraker.sh <RNAseq_R1> <RNAseq_R2> <genome.fasta>"
#       echo ""#
#       echo "To align RNAseq reads to genome and run Braker gene prediction program"
#       echo ""
#exit 0
#fi
module use /shared/software/GIF/modules
module load GIF/braker
module load samtools
module load GIF2/gmap-gsnap

#cp $GENEMARK_PATH/gm_key ~/.gm_key

TRANSCRIPTS="Araport11_genes.201606.cds.fasta"
GENOME="TAIR10_chr_all.fas"
BASE=$(basename ${GENOME%.*})
CWD="$(pwd)"



gmap_build -d ${BASE} -D ${CWD} ${GENOME}
gmap -d ${BASE} -D ${CWD} -f samse -n 0 -t 16 ${TRANSCRIPTS} > ${BASE}_rnaseq.sam 2> gmap.log
samtools view --threads 16 -b -o ${BASE}_rnaseq.bam ${BASE}_rnaseq.sam
samtools sort -m 7G -o ${BASE}_rnaseq_sorted.bam -T ${BASE}_rnaseq_temp --threads 16 ${BASE}_rnaseq.bam
braker.pl --cores=16 --overwrite --species=${BASE}.as.new --genome=${GENOME} --bam=${BASE}_rnaseq_sorted.bam --gff3

