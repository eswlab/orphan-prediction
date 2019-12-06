#!/bin/bash
# provide the case number with whcih the maker was run
# as the first argument
MAKERDIR="$1"
# re-do the index file as it will be scramblled due to mpi
rm ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log
/work/GIF/software/programs/maker/2.31.9/bin/maker -base ${MAKERDIR} -fix_nucleotides -dsindex
# make GFF3 and FASTA files for predictions
gff3_merge  -d ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log
fasta_merge -d ${MAKERDIR}.maker.output/${MAKERDIR}_master_datastore_index.log

