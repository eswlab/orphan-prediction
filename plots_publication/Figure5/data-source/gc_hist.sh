#!/bin/bash
file="$1"
base=$(basename $file |cut -f 1 -d "_")
f=$(cut -f 3 $file |grep -v "GC" |awk '$NF<0.3' |wc -l)
echo -e "<0.30\t$base\t$f"
for i in $(seq 0.30 0.01 0.65); do
g=$(cut -f 3 $file |grep -v "GC" |awk -v x=$i '$NF>=x && $NF<x+0.01' |wc -l)
echo -e "$i\t$base\t$g"
#echo -e "$i-$(echo "$i +0.01" |bc |awk '{printf "%.3f\n", $0}')\t$base\t$g"
done
h=$(cut -f 3 $file |grep -v "len" |awk '$NF>=0.65 && $NF<1' |wc -l)
echo -e ">0.65\t$base\t$h"
