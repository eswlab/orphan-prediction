#!/bin/bash

module load star
module load samtools

bbmap_folder=/work/LAS/mash-lab/jing/bin/bbmap
bbduk_ref=${bbmap_folder}/resources/adapters.fa
rRNA_ref=/work/LAS/mash-lab/jing/AT_ribo/rRNA.fa

line=$1

bbduk.sh in=raw/${line}.fastq out=${line}_clean.fq ref=${bbduk_ref} ktrim=r k=23 mink=11 hdist=1 qtrim=rl trimq=10
bbsplit.sh in=${line}_clean.fq ref=${rRNA_ref} basename=out_${line}_%.fq outu=cleanFQ/${line}_bbspout.fq

STAR --genomeDir star_index/ --runThreadN 48 --readFilesIn cleanFQ/${line}_bbspout.fq --outFilterScoreMinOverLread 0 --outFileNamePrefix star/${line}_ --outSAMtype BAM SortedByCoordinate

ribotricer detect-orfs --bam star/${line}_Aligned.sortedByCoord.out.bam --ribotricer_index BIND_index_candidate_orfs.tsv --prefix ribo_out/${line} --phase_score_cutoff 0.33 --min_valid_codons 5
