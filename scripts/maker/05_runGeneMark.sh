#!/bin/bash

# Load tools or install in your local computer
module load genemark-et/4.38

# Provide path of reference genome 
GENOME=$1
gmes_petap.pl --ES --cores 16 --sequence ${GENOME}
