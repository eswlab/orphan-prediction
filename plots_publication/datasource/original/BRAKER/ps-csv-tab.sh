#!/bin/bash
csv=$1
sed 's/ /_/g' $csv |sed 's/,/\t/g' |sed 's/"//g' | cut -f 2,5 > ${csv%.*}.tab
