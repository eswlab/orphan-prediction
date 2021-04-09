#!/bin/bash

echo "[1] Downloading genome"
curl -O https://www.arabidopsis.org/download_files/Genes/TAIR10_genome_release/TAIR10_chromosome_files/TAIR10_chr_all.fas

mkdir -p reference_data

mv TAIR10_chr_all.fas reference_data

echo "[2] Building Hisat2 Index"

#build hisat2 index
cd reference_data
hisat2-build TAIR10_chr_all.fas TAIR10_chr_all


