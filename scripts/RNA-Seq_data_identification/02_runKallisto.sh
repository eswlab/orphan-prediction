#!/bin/bash

# Load tools or install in your local computer.
module load kallisto/0.46.2

# Build index using annotated CDS sequences, only need once.
# Change Araport11_genes.201606.cds.fasta to sequences which you want to quantify.
# kallisto index -i ARAPORT11cds Araport11_genes.201606.cds.fasta.

# The builded transcriptome index is first input, SRR ID is second input. 
transcriptome="$1"
runid="$2"

# Create kallisto output folder for each RNA-Seq sample.
mkdir -p $(pwd)/kallisto_A11/${runid}
outdir=$(pwd)/kallisto_A11/${runid}

# Provide the path of RNA-Seq fastq.gz downloaded from first step.
r1=done_fastq_files/${runid}_1.fastq.gz
r2=done_fastq_files/${runid}_2.fastq.gz

# Align reads to transcriptome index
kallisto quant                      \
    --index="$transcriptome"        \
    --bootstrap-samples=100         \
    --output-dir="${outdir}" \
    --threads=16                     \
    # Our samples are paired-end reads, without known stranded information.
    # --fr-stranded or --rf-stranded for strand specific reads.
    # For single-end reads, add --single and only one fastq.gz file.
    $r1 $r2
    
# Move results and run details into results folder.
mv $kallisto_outdir/abundance.tsv $outdir/${runid}.tsv
mv $kallisto_outdir/abundance.h5 $outdir/${runid}.h5
mv $kallisto_outdir/run_info.json $outdir/${runid}.json
