#!/bin/bash

PATH=$PATH:/pylon5/mc48o5p/aseethar/transcript_assemblies/gmap/gmap-20180704/bin
fasta="$1"
for type in match_est match_cdna gene; do
if [ ! -f "${fasta%.*}_${type}.gff3.done" ]; then
gmap -D /pylon5/mc48o5p/aseethar/transcript_assemblies/gmap/gmap_index -d TAIR10_chr_all -B 4 -t 16 -f gff3_${type} ${fasta} > ${fasta%.*}_${type}.gff3 2> ${fasta%.*}_${type}.err
if [ $? -eq 0 ]; then
    touch "${fasta%.*}_${type}.gff3.done"
fi
fi
done

