#!/bin/bash

# Load tools or install in your local computer
module load transdecoder/3.0.1
module load seqtk

fasta=$1

# Extract all ORFs from transcripts.
TransDecoder.LongOrfs -t ${fasta}

# The above step extract both complete and incomplete ORFs.
# Incomplete ORFs used in mikado may affect the prediction and produce incomplete protein coding genes.
# Process the output files and only keep the complete ORFs for next step.

# Change to the transdecoder output folder and grep ID of complete ORFs.
cd ${fasta}.transdecoder_dir
grep "complete" longest_orfs.cds | cut -f1 -d" " | sed 's/>//' > complete.id

# Select complete ORFs from CDS, pep, and gff3 files, and replace them to the original longest_orfs files for next step.
seqtk subseq longest_orfs.cds complete.id > complete.cds
mv complete.cds longest_orfs.cds
seqtk subseq longest_orfs.pep complete.id > complete.pep
mv complete.pep longest_orfs.pep
grep -Fwf complete.id longest_orfs.gff3 > complete.gff3
mv complete.gff3 longest_orfs.gff3
cd ..

# Predict potential CDS.
TransDecoder.Predict -t ${fasta} --cpu 64
