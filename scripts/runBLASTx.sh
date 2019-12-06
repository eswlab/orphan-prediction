#!/bin/bash
transcripts=$1
ml load ncbi-blast
blastn  \
	-max_target_seqs 5 \
	-num_threads 28 \
	-query ${transcripts}
	-outfmt 5 \
	-db TAIR10_chr_all.fas \
	-evalue 0.000001 2> blast.log | sed '/^$/d' > mikado.blast.xml

