#!/bin/bash

# Load tools or install in your local computer
module load cufflinks
module load genometools

gff=$1
ref=$2

# Extract predicted protein squence from gene models
gffread ${gff} -g ${ref} -y pep.fa

# gffread mark stop codon as ".", should change "." to "*" for cd-hit
sed -i 's/\.$/*/' pep.fa

# You could find cd-hit in the transdecoder bin, or install cd-hit seperately.
# Here remove the identically protein by define "-c" as 1. You can also change the identical as you need, -c is identity from 0 to 1.
/opt/rit/spack-app/linux-rhel7-x86_64/gcc-4.8.5/transdecoder-3.0.1-53ns2nerx6pvd23gs4rhc35636r53x6l/util/bin/cd-hit -i pep.fa -T 0 -c 1 -M 0 -d 0 -o filter.pep.fa

# Get filtered transcript and gene ID.
grep ">" filter.pep.fa | cut -f1 -d" " | sed 's/>//' > nr-trans.txt
cut -f1-2 -d"." nr-trans.txt | sort -u > nr-gene.txt

# Obtain a gff file with non-redundant CDSs.
grep -Fwf nr-trans.txt ${gff} > trans.gff3
awk '$3=="gene"' ${gff} | grep -Fwf nr-gene.txt - > gene.gff3
cat gene.gff3 trans.gff3 | sed '1 i\##gff-version 3' | gt gff3 -sort -tidy -retainids > nr.gff3
