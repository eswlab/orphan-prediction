#!/bin/bash
mkdir -p sra-small
cd sra-small
ml sratools
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381966
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381967
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381968
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381969
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381970
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381971
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381972
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381973
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381974
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381975
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381976
prefetch --max-size 100G --transport ascp --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" SRR4381977
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381966.sra
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381967.sra
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381968.sra
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381969.sra
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381970.sra
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381971.sra
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381972.sra
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381973.sra
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381974.sra
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381975.sra
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381976.sra
fastq-dump --split-files --origfmt --gzip ~/ncbi/public/sra/SRR4381977.sra
cat *.fastq.gz >> forward_reads.fq.gz
