#/bin/bash

# Load tools or install in your local computer
module load maker/2.31.10

# Define maker output base name
MAKERDIR="$1"

# Use mpi to run maker paralle.
# You can also run maker with 1 node, but maybe slow for large data.
mpiexec \
	-n 64 \
	maker \
	-base ${MAKERDIR} \
	-fix_nucleotides
