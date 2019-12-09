#!/bin/bash
refmap=$1
stats=$2
ps=$3
grep -v "^ref_id" $refmap | cut -f 3,5 | grep -vw "^NA" | awk '$2!=0' > temp.tid-nF1.txt
grep -v "qseqid" $ps > temp.ps
awk 'BEGIN{OFS=FS="\t"}FNR==NR{a[$1]=$2 FS $3;next}{ print $0, a[$1]}' ${stats} temp.ps |tr -s "\t" > temp.ps.stats
awk 'BEGIN{OFS=FS="\t"}FNR==NR{a[$1]=$2 FS $3;next}{ print $0, a[$1]}' temp.tid-nF1.txt temp.ps.stats |\
   awk '{ if ( NF == 4 ) {print $0"0.0"} else {print $0} }' |\
  sed 's/ /\t/g' |\
  sed 's/\t$//g' |\
  tr -s "\t" |\
  awk 'BEGIN{OFS=FS="\t"} {print $1,$3,$4,$2,$5}' > temp.ps.stats.nf1
rm transcripts.stats.ps.nf1.txt genes.stats.ps.nf1.txt &> /dev/null
echo -e "ID\tlen\tgc\tPS\tPresence" > transcripts.stats.ps.nf1.txt
awk '{ if ( $NF == 0 ) {print $0"\tno-match"} else {print $0"\tmatch"} }' temp.ps.stats.nf1 |cut -f 1-4,6 >> transcripts.stats.ps.nf1.txt
echo -e "ID\tlen\tgc\tPS\tPresence" > genes.stats.ps.nf1.txt
awk '{ if ( $NF == 0 ) {print $0"\tno-match"} else {print $0"\tmatch"} }' temp.ps.stats.nf1 | sed 's/\-/\t/1' | cut -f 1,3-5,7 |sort -k1,1 -u >> genes.stats.ps.nf1.txt
