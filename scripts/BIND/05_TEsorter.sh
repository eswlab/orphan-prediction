#!/bin/bash

# Install TEsorter to your computer.

# Run TEsorter to filter out TE mapped proteins.
prot=$1
gff=$2
TEsorter ${prot} -p 64 -st prot

# Find transcript ID corresponding to the TE mapped proteins.
grep -v "^#" ${prot}.rexdb.cls.tsv | cut -f1 | sort -u > TE-trans.txt

# Get the transcript and gene ID not mapped to TE.
grep ">" {prot} | cut -f1 -d" " | sed 's/>//' | sort -u | comm -23 - TE-trans.txt > nonTE-trans.txt
cut -f1-2 -d"." nonTE-trans.txt | sort -u > nonTE-gene.txt

# Obtain a gff file filter out TE mapped proteins.
grep -Fwf nonTE-trans.txt ${gff} > trans.gff3
awk '$3=="gene"' ${gff} | grep -Fwf nonTE-gene.txt - > gene.gff3
cat gene.gff3 trans.gff3 | sed '1 i\##gff-version 3' | gt gff3 -sort -tidy -retainids > noTE.gff3
