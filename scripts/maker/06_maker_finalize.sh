#!/bin/bash

# Load tools or install in your local computer
module load maker/2.31.10

# provide the case number with whcih the maker was run
# as the first argument
MAKERDIR="$1"

# Re-do the index file as it will be scramblled due to mpi, so remove the log file.
rm ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log
maker -base ${MAKERDIR} -fix_nucleotides -dsindex

# Make GFF3 and FASTA files for predictions
gff3_merge  -d ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log
fasta_merge -d ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log
