#!/bin/bash
module load perl/5.18.4-threads
module load transdecoder/3.0.1
fasta="$1"

TransDecoder.LongOrfs -t $fasta
TransDecoder.Predict -t $fasta --cpu 40

