#!/bin/bash
# works on L3
# change this to condo is you need to run it there
# needs rnaseq reads as well as the genome to be annotated
# if you have multiple RNA seq libraries merge them together (all R1's and all R2's seperately)
module load hisat2
module load GIF/braker

cp $GENEMARK_PATH/gm_key ~/.gm_key

R1="$1"
GENOME="$2"
BASE=$(basename ${GENOME%.*})
read=$(basename ${R1%.*})

hisat2-build ${GENOME} ${GENOME%.*}
hisat2 -p 16 -x ${GENOME%.*} -U ${R1}  > ${BASE}_${read}.sam
samtools view --threads 16 -b -o ${BASE}_${read}.bam ${BASE}_${read}.sam
samtools sort -m 8G -o ${BASE}_${read}_sorted.bam -T ${BASE}_${read}.temp --threads 16 ${BASE}_${read}.bam
braker.pl --cores=16 --overwrite --species=${BASE}_${read} --genome=${GENOME} --bam=${BASE}_${read}_sorted.bam --gff3
