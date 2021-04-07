#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=64
#SBATCH -t 500:00:00
#SBATCH -J transdecoder
#SBATCH -o transdecoder.o%j
#SBATCH -e transdecoder.e%j

module load transdecoder/3.0.1

fasta=$1

TransDecoder.LongOrfs -t ${fasta}

# The above step extract both complete and incomplete ORFs.
# Incomplete ORFs used in mikado may affect the prediction and produce incomplete protein coding genes.
# Process the output files and only keep the complete ORFs for next step.

cd ${fasta}.transdecoder_dir
grep "complete" longest_orfs.cds | cut -f1 -d" " | sed 's/>//' > complete.id
module load seqtk
seqtk subseq longest_orfs.cds complete.id > complete.cds
mv complete.cds longest_orfs.cds
seqtk subseq longest_orfs.pep complete.id > complete.pep
mv complete.pep longest_orfs.pep
grep -Fwf complete.id longest_orfs.gff3 > complete.gff3
mv complete.gff3 longest_orfs.gff3
cd ..

TransDecoder.Predict -t ${fasta} --cpu 64
