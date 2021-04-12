#!/bin/bash

# Load tools or install in your local computer
module load hisat2/2.2.0
module load samtools/1.10

# Define path for input RNA-Seq data and reference genome sequence.
line=$1
GENOME=$2

# Buid index for hisat2.
# Only need to do once.
# hisat2-build ${GENOME} ${GENOME%.*}

# Alignment by hisat2.
# Here, we only used paired-end RNA-seq samples. You can use "-U" instead of "-1 and -2"  if your sample is single-end RNA-Seq data.
# Note: must add "--dta-cufflinks" for cufflinks.
hisat2 -p 16 -x ${GENOME%.*} --dta-cufflinks -1 ${line}_1.fastq.gz -2 ${line}_2.fastq.gz > ${line}.sam

# Convert sam to bam, and sort bam file.
samtools view --threads 16 -b -o ${line}.bam ${line}.sam
samtools sort -m 5G -o ${line}_sorted.bam -T ${line}_temp --threads 16 ${line}.bam
