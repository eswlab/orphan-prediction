#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=64
#SBATCH -t 500:00:00
#SBATCH -J transdecoder
#SBATCH -o transdecoder.o%j
#SBATCH -e transdecoder.e%j

module load transdecoder

TransDecoder.LongOrfs -t mikado_prepared_ref.fasta 
cd mikado_prepared_ref.fasta.transdecoder_dir
grep "complete" longest_orfs.cds | cut -f1 -d" " | sed 's/>//' > complete.id
module load seqtk
seqtk subseq longest_orfs.cds complete.id > complete.cds
/opt/rit/spack-app/linux-rhel7-x86_64/gcc-4.8.5/transdecoder-3.0.1-53ns2nerx6pvd23gs4rhc35636r53x6l/util/get_top_longest_fasta_entries.pl complete.cds 5000 >complete.cds.top5000
/opt/rit/spack-app/linux-rhel7-x86_64/gcc-4.8.5/transdecoder-3.0.1-53ns2nerx6pvd23gs4rhc35636r53x6l/util/bin/cd-hit-est -r 1 -i complete.cds.top5000 -T 0 -c 0.80 -o complete.cds.nr80 -M 0 -d 0
/opt/rit/spack-app/linux-rhel7-x86_64/gcc-4.8.5/transdecoder-3.0.1-53ns2nerx6pvd23gs4rhc35636r53x6l/util/get_top_longest_fasta_entries.pl complete.cds.nr80 500 > complete.cds.nr80.top500
mkdir complete.cds.transdecoder_dir
mv base_freqs.dat longest_orfs.gff3 complete.cds.transdecoder_dir
mv complete.cds.nr80.top500 complete.cds.transdecoder_dir/longest_orfs.cds.top_500_longest
cp complete.cds complete.cds.transdecoder_dir/longest_orfs.cds

cd complete.cds.transdecoder_dir
touch base_freqs.dat.ok longest_orfs.cds.top_500_longest.ok
cd ..
TransDecoder.Predict -t complete.cds --cpu 64
