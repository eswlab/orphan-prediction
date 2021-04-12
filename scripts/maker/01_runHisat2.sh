#!/bin/bash

# Load tools or install in your local computer
module load hisat2/2.2.0
module load samtools/1.10

# Define path for input RNA-Seq data and reference genome sequence.
R1=$1
R2=$2
GENOME=$3

# Buid index for hisat2.
hisat2-build ${GENOME} ${GENOME%.*}

# Alignment by hisat2.
hisat2 -p 16 -x ${GENOME%.*} -1 ${R1} -2 ${R2} > ${GENOME%.*}_rnaseq.sam

# Convert sam to bam, and sort bam file.
samtools view --threads 16 -b -o ${GENOME%.*}_rnaseq.bam ${GENOME%.*}_rnaseq.sam
samtools sort -m 5G -o ${BASE}_rnaseq_sorted.bam -T ${BASE}_temp --threads 16 ${BASE}_rnaseq.bam
