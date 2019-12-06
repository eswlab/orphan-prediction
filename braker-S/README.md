# Braker for "large" dataset


Forward reads is named `forward_reads.fq.gz` and it is single end dataset. The `runBraker.sh` script is run providing reads and genome as arguments

```bash
runBrakerS.sh forward_reads.fq.gz TAIR10_chr_all.fas
```


where the runBraker.sh script is:

```bash
#!/bin/bash
# needs rnaseq reads as well as the genome to be annotated
# if you have multiple RNA seq libraries merge them together (all R1's and all R2's seperately)
module load hisat2
module load GIF/braker
cp $GENEMARK_PATH/gm_key ~/.gm_key
R1="$1"
GENOME="$2"
BASE=$(basename ${GENOME%.*})
read=$(basename ${R1%.*})
hisat2-build ${GENOME} ${GENOME%.*}
hisat2 -p 16 -x ${GENOME%.*} -U ${R1}  > ${BASE}_${read}.sam
samtools view --threads 16 -b -o ${BASE}_${read}.bam ${BASE}_${read}.sam
samtools sort -m 8G -o ${BASE}_${read}_sorted.bam -T ${BASE}_${read}.temp --threads 16 ${BASE}_${read}.bam
braker.pl --cores=16 --overwrite --species=${BASE}_${read} --genome=${GENOME} --bam=${BASE}_${read}_sorted.bam --gff3
```

