#!/bin/bash
GFF1=$1
GFF2=$2
weights=$3
genome=TAIR10_chr_all.fas
cat ${GFF1} <( grep -v "^#" ${GFF2}) > gene_predictions.gff3

partition_EVM_inputs.pl \
   --genome ${genome} \
   --gene_predictions gene_predictions.gff3 \
   --segmentSize 100000 \
   --overlapSize 10000 \
   --partition_listing partitions_list.out
write_EVM_commands.pl \
   --genome ${genome} \
   --weights $weights \
   --gene_predictions gene_predictions.gff3 \
   --output_file_name evm.out  \
   --partitions partitions_list.out >  commands.list
execute_EVM_commands.pl commands.list | tee run.log
recombine_EVM_partial_outputs.pl \
   --partitions partitions_list.out \
   --output_file_name evm.out
convert_EVM_outputs_to_GFF3.pl  \
   --partitions partitions_list.out \
   --output evm.out  \
   --genome ${genome}
find . -regex ".*evm.out.gff3" -exec cat {} \; > EVM.all.gff3
