#!/bin/bash
#pacakges needed
export PATH="/home/aseethar/miniconda3/bin:$PATH"
source activate mikado
module load perl/5.18.4-threads
module load blast/2.7.1
module load transdecoder/3.0.1
#setup variables
genome=TAIR10_chr_all.fas
bam="pooled.bam"
list="list.txt"
#run splice junction prediction
junctions="/pylon5/mc48o5p/aseethar/pooled_mikado/4_portcullis/portcullis_out/3-filt/portcullis_filtered.pass.junctions.bed"
#configure
mikado configure \
   --list $list \
   --reference $genome \
   --mode permissive \
   --scoring plants.yaml \
   --copy-scoring plants.yaml \
   --junctions $junctions configuration.yaml
#prepare
mikado prepare \
   --json-conf configuration.yaml
#blast db
makeblastdb \
   -in TAIR10_chr_all.fas \
   -dbtype nucl \
   -parse_seqids
#blast
blastn \
   -max_target_seqs 5 \
   -num_threads 28 \
   -query mikado_prepared.fasta \
   -outfmt 5 \
   -db TAIR10_chr_all.fas \
   -evalue 0.000001 2> blast.log | sed '/^$/d' > mikado.blast.xml
blastxml=mikado.blast.xml
#transdecoder
TransDecoder.LongOrfs \
   -t mikado_prepared.fasta
TransDecoder.Predict \
   -t mikado_prepared.fasta \
   --cpu 28
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
