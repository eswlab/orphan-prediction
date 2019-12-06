#!/bin/bash
sed -i 's/Arabidopsis_thaliana/Arabidopsis thaliana/g' $1
sed -i 's/cellular_organisms/Cellular Organisms/g' $1
sed -i 's/malvids/Malvids/g' $1
sed -i 's/rosids/Rosids/g' $1
