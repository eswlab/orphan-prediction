# Running BUSCO on your predictions

Once you have the `gff` file your predictions, use the genomes to extract the CDS sequences (using the `gffread` from the CUFFLINKS package). On these transcripts, you can run BUSCO to find the conserved genes. Below are the steps:


### Input files needed:

1. Predictions (GFF format)
2. Genome (fasta format)

### Programs needed

1. `gffread` from `cufflinks` package
2. `BUSCO`
3. BUSCO Lineages specific to your species downloaded from BUSCO website

### Methods

```bash
predictions.gff # gff file from BIND or MIND workflow
genome.fasta # fasta file for your genome, used for the BIND/MIND

# extract CDS
module load cufflinks
gffread predictions.gff3 -g genome.fasta -x predictions-cds.fa -y predictions-pep.fa

# run BUSCO
module load busco
cds=predictions-cds.fa
run_BUSCO.py \
   --mode transcriptome \
   --lineage_path /path/to/busco_profiles/liliopsida_odb10 \ # plant busco profile used here, change this to your species specific lineage \
   --cpu 36 \
   --in ${cds} \
   --out ${cds%.*} \
   --force \
   --restart
```

### Output

With the above example, the output files will be located in the folder named `predictions-cds`. The primary file that will have the BUSCO summary will be named with the prefix `short_summary`. Sample contents are as follows:


```
# BUSCO version is: 3.0.2
# The lineage dataset is: liliopsida_odb10 (Creation date: 2017-12-01, number of species: 18, number of BUSCOs: 3278)
# To reproduce this run: python /work/LAS/mash-lab/arnstrm/miniconda/envs/busco/bin/run_BUSCO.py -i predictions-cds.fasta -o predictions-cds -l /path/to/busco_profiles/liliopsida_odb10/ -m transcriptome  -c 36 -t /mnt/bgfs/arnstrm/3044649/ -sp maize
#
# Summarized benchmarking in BUSCO notation for file predictions-cds.fasta
# BUSCO was run in mode: genome

       C:95.2%[S:83.3%,D:11.9%],F:2.3%,M:2.5%,n:3278

       3119    Complete BUSCOs (C)
       2730    Complete and single-copy BUSCOs (S)
       389     Complete and duplicated BUSCOs (D)
       77      Fragmented BUSCOs (F)
       82      Missing BUSCOs (M)
       3278    Total BUSCO groups searched
```
