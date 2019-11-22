#!/bin/bash
export PATH="/home/aseethar/miniconda3/bin:$PATH"
source activate mikado
list=list.txt
genome=TAIR10_chr_all.fas
junctions=portcullis_filtered.pass.junctions.bed
orfs=mikado_prepared.fasta.transdecoder.bed
blastxml=mikado.blast.xml

mikado configure \
   --list $list \
   --reference $genome \
   --mode permissive \
   --scoring plants.yaml \
   --copy-scoring plants.yaml \
   --junctions $junctions configuration2.yaml

mikado prepare \
   --json-conf configuration2.yaml

mikado serialise \
   --start-method spawn \
   --procs 28 \
   --blast_targets ${genome} \
   --json-conf configuration2.yaml \
   --xml ${blastxml} \
   --orfs ${orfs} 

mikado pick \
   --start-method spawn \
   --procs 28 \
   --json-conf configuration2.yaml \
   --subloci_out mikado.subloci.gff3
