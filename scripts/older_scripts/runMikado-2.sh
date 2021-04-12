#!/bin/bash
#pacakges needed
export PATH="/home/aseethar/miniconda3/bin:$PATH"
source activate mikado
module load perl/5.18.4-threads
module load blast/2.7.1
module load transdecoder/3.0.1
#setup variables
genome=TAIR10_chr_all.fas
list="list.txt"
junctions="portcullis_filtered.pass.junctions.bed"
blastxml=mikado.blast.xml
orfs=$(find $(pwd) -name "mikado_prepared.fasta.transdecoder.bed")
#serialise
mikado serialise \
   --start-method spawn \
   --procs 28 \
   --blast_targets ${genome} \
   --json-conf configuration.yaml \
   --xml ${blastxml} \
   --orfs ${orfs}
#pick
mikado pick \
   --start-method spawn \
   --procs 28 \
   --json-conf configuration.yaml \
   --subloci_out mikado.subloci.gff3
