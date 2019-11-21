#!/bin/bash
# provide the case number with whcih the maker was run
# as the first argument
MAKERDIR="$1"
# re-do the index file as it will be scramblled due to mpi
rm ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log
/work/GIF/software/programs/maker/2.31.9/bin/maker -base ${MAKERDIR} -fix_nucleotides -dsindex
# make GFF3 and FASTA files for predictions
gff3_merge  -d ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log
fasta_merge -d ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log
## retrain snap
mkdir ${MAKERDIR}_SNAP
cd  ${MAKERDIR}_SNAP
maker2zff ../${MAKERDIR}.all.gff
fathom genome.ann genome.dna -categorize 1000
fathom -export 1000 -plus uni.ann uni.dna
forge export.ann export.dna
hmm-assembler.pl ${MAKERDIR} . > ../${MAKERDIR}.snap.hmm
cd ..
# train augustus
module load gsnap
module load samtools
module rm perl
# map first round transcritps to genome using GMAP
gmap   \
   -d TAIR10 \
   -D /work/LAS/mash-lab/arnstrm/20170320_ArabidopsosGenePrediction_as/04_maker/common_files \
   -t 16 \
   -B 5 \
   -A -f samse \
   --input-buffer-size=10000000 \
   --output-buffer-size=10000000 \
     ${MAKERDIR}.all.maker.transcripts.fasta > ${MAKERDIR}_se.sam
# convert SAM to BAM and sort
SAM="${MAKERDIR}_se.sam"
samtools view --threads 16 -b -o ${SAM%.*}.bam ${SAM}
samtools sort -m 4G -o ${SAM%.*}_sorted.bam -T ${SAM%.*}_temp --threads 16  ${SAM%.*}.bam
BAM="${SAM%.*}_sorted.bam"
SPP="${MAKERDIR}_20170404"
# training using BRAKER scripts
module load GIF/braker
module rm perl
perl /work/GIF/software/programs/braker/1.9/braker.pl --cores=16 --overwrite --species=${SPP} --genome=TAIR10_chr_all.fas --bam=${BAM} --gff3

