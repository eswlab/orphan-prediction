#!/bin/bash
file="$1"
base=$(basename $file |cut -f 1 -d "_")
for i in $(seq 0 100 4600); do
g=$(cut -f 2 $file |grep -v "len" |awk -v x=$i '$NF>=x && $NF<x+100' |wc -l)
echo -e "$((i+100))\t$base\t$g"
done
h=$(cut -f 2 $file |grep -v "len" |awk '$NF>=4500 && $NF<15000' |wc -l)
echo -e ">4500\t$base\t$h"
