#!/bin/bash
ps=$1
sed 's/_/\t/1' $ps |cut -f 1,3 > ${ps%.*}-new.tab
