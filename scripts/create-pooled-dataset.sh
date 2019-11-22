#!/bin/bash
mkdir sra-pooled
cd sra-pooled
cat ../sra-small/forward_reads.fq.gz ../sra-medium/forward_reads.fq.gz ../sra-large/forward_reads.fq.gz >> forward_reads.fq.gz
cat ../sra-small/reverse_reads.fq.gz ../sra-medium/reverse_reads.fq.gz ../sra-large/reverse_reads.fq.gz >> reverse_reads.fq.gz

