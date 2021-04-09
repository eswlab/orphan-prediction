#!/bin/bash

# Load tools or install in your local computer
module load perl/5.18.4-threads
module load transdecoder/3.0.1

fasta=$1
# Extract all ORFs in the predicted transcripts.
TransDecoder.LongOrfs -t $fasta

# Predict potential CDS from all ORFs. 
# The output include complete and incomplete CDS.
# It's better to filter out incomplete ORFs before prediction if you want only complete CDSs.
TransDecoder.Predict -t $fasta --cpu 40
