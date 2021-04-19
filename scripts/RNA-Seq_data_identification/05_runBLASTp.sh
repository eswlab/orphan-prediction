#!/bin/bash

# Load tools or install in your local computer
module load blast-plus/3.11.0

# Define query protein file (e.g. 3702.faa), target taxid, and BLAST output file.
target=$1
query=$2
outfile=${target}.txt

# Build database for each species using downloaded protein sequence from step 04.
makeblastdb –in uniprot-seqs/${target}.faa –dbtype prot –parse_seqids -out ${target}

# Run BLASTP for each target species
blastp \
 -query ${query} \
 -db ${target} \
 -out ${outfile} \
 -num_threads 8 \
 -outfmt '6 qseqid sseqid qstart qend sstart send evalue score' 
