#!/bin/bash

# Build index for transcriptome, only do once
# Build index with decoys could improve accuracy, check https://combine-lab.github.io/alevin-tutorial/2019/selective-alignment/

# cat final.cdna.fa TAIR10_chr_all.fas > final.gentrome.fa
# grep "^>" TAIR10_chr_all.fas | cut -d " " -f 1 > decoys.txt
# sed -i.bak -e 's/>//g' decoys.txt
# salmon index -t final.gentrome.fa -d decoys.txt -p 16 -i final.salmon_index --keepDuplicates

# Quantification for each sample
salmon quant -i final.salmon_index -l A -1 ${srr}_1.fastq.gz -2 ${srr}_2.fastq.gz --validateMappings --gcBias --noBiasLengthThreshold -p 64 -o ${srr}
