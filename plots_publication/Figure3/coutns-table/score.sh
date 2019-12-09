#!/bin/bash
file=$1
base=$(basename ${file} |cut -f 1 -d "_");
echo -e "Score\tMethod\tCounts"  > ${base}.score.distrib.txt
cut -f 1,5 $file |\
	sed 's/\./\t/1' |\
	cut -f 1,3 |\
	sort -k1,1 -u |\
	cut -f 2|\
	grep -v "nF1" |\
	sed 's/NA/0/g' |\
	sort -k1,1 -n |\
	perl -lne '$h{int($_)}++; END{for $n (sort {$a <=> $b} keys %h) {print "$n\t$h{$n}"}}' |\
	awk -v x=$base '{print $1"\t"x"\t"$2}' >> ${base}.score.distrib.txt


a=$(cut -f 1,5 $file |\
        sed 's/\./\t/1' |\
        cut -f 1,3 |\
        sort -k1,1 -u |\
        cut -f 2|\
        grep -v "nF1" |\
        sed 's/NA/Absent/g' | awk '$1=="Absent" || $1==0 ' |wc -l)
c=$(cut -f 1,5 $file |\
        sed 's/\./\t/1' |\
        cut -f 1,3 |\
        sort -k1,1 -u |\
        cut -f 2|\
        grep -v "nF1" |\
        sed 's/NA/0/g' | awk '$1>0 && $1<=25' |wc -l)
d=$(cut -f 1,5 $file |\
        sed 's/\./\t/1' |\
        cut -f 1,3 |\
        sort -k1,1 -u |\
        cut -f 2|\
        grep -v "nF1" |\
        sed 's/NA/0/g' | awk '$1>25 && $1<=50' |wc -l)
e=$(cut -f 1,5 $file |\
        sed 's/\./\t/1' |\
        cut -f 1,3 |\
        sort -k1,1 -u |\
        cut -f 2|\
        grep -v "nF1" |\
        sed 's/NA/0/g' | awk '$1>50 && $1<=75' |wc -l)
f=$(cut -f 1,5 $file |\
        sed 's/\./\t/1' |\
        cut -f 1,3 |\
        sort -k1,1 -u |\
        cut -f 2|\
        grep -v "nF1" |\
        sed 's/NA/0/g'| awk '$1>75 && $1<=100' |wc -l)
echo -e "Absent\t$base\t$a" > ${base}.score.stacked.txt
echo -e "1-25\t$base\t$c" >> ${base}.score.stacked.txt
echo -e "26-50\t$base\t$d" >> ${base}.score.stacked.txt
echo -e "51-75\t$base\t$e" >> ${base}.score.stacked.txt
echo -e "76-100\t$base\t$f" >> ${base}.score.stacked.txt

