#!/bin/bash

# Load tools or install in your local computer
module load maker/2.31.10
module load gsnap/2019-05-12
module load samtools/1.10
module load braker/2.1.2
module rm perl

# Provide the folder name with whcih the maker was run in previous step
MAKERDIR="$1"

# Re-do the index file as it will be scramblled due to mpi, so remove the log file.
rm ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log
maker -base ${MAKERDIR} -fix_nucleotides -dsindex

# Make GFF3 and FASTA files for predictions.
gff3_merge  -d ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log
fasta_merge -d ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log

## Retrain snap
mkdir ${MAKERDIR}_SNAP
cd  ${MAKERDIR}_SNAP
maker2zff ../${MAKERDIR}.all.gff
fathom genome.ann genome.dna -categorize 1000
fathom -export 1000 -plus uni.ann uni.dna
forge export.ann export.dna
hmm-assembler.pl ${MAKERDIR} . > ../${MAKERDIR}.snap.hmm
cd ..

# Train augustus
# Map first round transcritps to genome using GMAP
gmap   \
   # Define the name of genome database
   -d TAIR10 \
   # Provide the folder where genome sequence in
   -D common_files \
   -t 16 \
   -B 5 \
   # set output format
   -A -f samse \
   --input-buffer-size=10000000 \
   --output-buffer-size=10000000 \
     ${MAKERDIR}.all.maker.transcripts.fasta > ${MAKERDIR}_se.sam
     
# Convert SAM to BAM and sort.
SAM="${MAKERDIR}_se.sam"
BAM="${SAM%.*}_sorted.bam"
samtools view --threads 16 -b -o ${SAM%.*}.bam ${SAM}
samtools sort -m 4G -o ${BAM} -T ${SAM%.*}_temp --threads 16  ${SAM%.*}.bam

# training using BRAKER scripts
# Define your species name, cannot be existing name in augustus/config/species/ 
SPP="${MAKERDIR}_20170404"
braker.pl --cores=16 --overwrite --species=${SPP} --genome=TAIR10_chr_all.fas --bam=${BAM} --gff3
