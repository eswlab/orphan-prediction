# Run BRAKER

- To simplify handling of files, combine all the forward reads to one file and all the reverse reads to another.
```bash
cat *_1.fastq.gz >> forward_reads.fq.gz
cat *_2.fastq.gz >> reverse_reads.fq.gz
```

- Do RNA-Seq alignment by Hisat2:
```bash
./01_runHisat2.sh forward_reads.fq.gz reverse_reads.fq.gz TAIR10_chr_all.fas
```

- Run BRAKER:
```bash
./02_runBraker.sh TAIR10_chr_all.fas TAIR10_rnaseq.bam
```
