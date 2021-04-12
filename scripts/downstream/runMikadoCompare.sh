#!/bin/bash
source activate mikado
gff=$1
ref=Arabidopsis-ps_tidy.gff3
mikado compare -r $ref -p $gff -o ${gff%.*}-compared -l ${gff%.*}-compared.log
