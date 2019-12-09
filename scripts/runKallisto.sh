#!/bin/bash
module purge
module load kallisto

transcriptome="$1"
runid="$2"
mkdir -p $(pwd)/kallisto_A11/${runid}
outdir=$(pwd)/kallisto_A11/${runid}

r1=done_fastq_files/${runid}_1.fastq.gz
r2=done_fastq_files/${runid}_2.fastq.gz
# align reads to transcriptome index
kallisto quant                      \
    --index="$transcriptome"        \
    --bootstrap-samples=100         \
    --output-dir="${outdir}" \
    --threads=16                     \
    $r1 $r2
# move results and run details into results folder
mv $kallisto_outdir/abundance.tsv $outdir/${runid}.tsv
mv $kallisto_outdir/abundance.h5 $outdir/${runid}.h5
mv $kallisto_outdir/run_info.json $outdir/${runid}.json
