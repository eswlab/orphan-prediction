#!/bin/bash
file=$1
base=$(echo $file |cut -f 1 -d "_");
first=$(cut -f 4 $file | grep -v "nF1" | grep -Ewc "NA|0.0")
second=$(cut -f 4 $file | grep -v "nF1" | awk '$1>0 && $1<=25' |wc -l)
third=$(cut -f 4 $file | grep -v "nF1" | awk '$1>25 && $1<=50' |wc -l)
fourth=$(cut -f 4 $file | grep -v "nF1" | awk '$1>50 && $1<=75' |wc -l)
fifth=$(cut -f 4 $file | grep -v "nF1" | awk '$1>75 && $1<=100' |wc -l)
echo -e "Absent\t$base\t$first"
echo -e "1-25\t$base\t$second"
echo -e "26-50\t$base\t$third"
echo -e "51-75\t$base\t$fourth"
echo -e "76-100\t$base\t$fifth"
