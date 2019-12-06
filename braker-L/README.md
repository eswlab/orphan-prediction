# Braker for "large" dataset


Forward reads is named `forward_reads.fq.gz` and reverse reads are named `reverse_reads.fq.gz`. The `runBraker.sh` script is run providing both arguments

```bash
runBraker.sh forward_reads.fq.gz reverse_reads.fq.gz TAIR10_chr_all.fas
```


where the runBraker.sh script is:

```bash
#!/bin/bash
# needs rnaseq reads as well as the genome to be annotated
# if you have multiple RNA seq libraries merge them together (all R1's and all R2's seperately)
if [ $# -lt 3 ] ; then
        echo "usage: runBraker.sh <RNAseq_R1> <RNAseq_R2> <genome.fasta>"
        echo ""
        echo "To align RNAseq reads to genome and run Braker gene prediction program"
        echo ""
exit 0
fi
module load hisat2
module load GIF/braker

cp $GENEMARK_PATH/gm_key ~/.gm_key

R1="$1"
R2="$2"
GENOME="$3"
BASE=$(basename ${GENOME%.*})
hisat2-build ${GENOME} ${GENOME%.*}
hisat2 -p 16 -x ${GENOME%.*} -1 ${R1} -2 ${R2} > ${BASE}_rnaseq.sam
samtools view --threads 16 -b -o ${BASE}_rnaseq.bam ${BASE}_rnaseq.sam
samtools sort -m 5G -o ${BASE}_rnaseq_sorted.bam -T ${BASE}_temp --threads 16 ${BASE}_rnaseq.bam
braker.pl --cores=16 --overwrite --species=${BASE}_med --genome=${GENOME} --bam=${BASE}_rnaseq_sorted.bam --gff3
```

