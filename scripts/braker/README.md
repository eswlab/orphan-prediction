**See overview and documentation:**[![Documentation Status](https://readthedocs.org/projects/orphan-prediction/badge/?version=latest)](https://orphan-prediction.readthedocs.io/en/latest/)

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

   **If you have difficulty to install BRAKER, we suggest you to download the singularity container for this step at [here](https://github.com/aseetharam/braker).**

  To use the container, follow the instruction of the container to install and copy directory.

  ```bash
  ./02_runBraker_singularity.sh TAIR10_chr_all.fas TAIR10_rnaseq.bam
  ```

_Note: We only used RNA-Seq as evidence in our cases. BRAKER also accept protein evidence in different prediction mode. However, It is not always best to use all evidence. You can test and determine which one is best for the species you are working on. See the difference of different modes [here](https://github.com/Gaius-Augustus/BRAKER#running-braker)._
