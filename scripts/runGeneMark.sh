#!/bin/bash
GENOME=$1
module use /shared/software/GIF/modules
module load GeneMark-ES
gmes_petap.pl --ES --cores 16 --sequence $GENOME
