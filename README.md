# Orphan gene prediction and optimization using BIND and MIND workflows:

## Overview

Here is the overview of steps, evidence based predictions are common for both MIND and BIND. MAKER predictions are combined with evidence models to generate MIND and BRAKER predictions are combined with evidence models to generate BIND.

1. Finding Orphan Enriched RNAseq dataset form NCBI:
	- Search RNAseq datasets for your organism on NCBI, filter Runs (SRR) for Illumina, paired-end, HiSeq 2500 or newer.
	- Download Runs from NCBI (SRA-toolkit)
	- run quantification against current gene models using kallisto
	- run phylostratR on current gene models to identify orphans
	- Rank the SRRs with highest number of expressed orphans and select feasible amounts of data to work with.

2. Run BRAKER
	- Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
	- Generate BAM file for each SRA-SRR id, merge them to generate a single sorted BAM file
	- Run BRAKER

2. Run MAKER

	- Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
	- Generate BAM file for each SRA-SRR id, merge them to generate a single sorted BAM file
	- Run Trinity to generate transcriptome assembly using the BAM file
	- Run TransDecoder on Trinity transcripts to predict ORFs and translate them to protein
	- Download SwissProt curated Viridaplantae proteins
	- Run MAKER with transcripts (Trinity), proteins (TransDecoder and SwissProt), with homology only mode
	- Use the MAKER predictions to train: SNAP and AUGUSTUS. Self-train GeneMark
	- Run second round of MAKER with above three ab initio predictions along with the previous round MAKER results.

3. Run evidence based predictions:

	- Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
	- Generate BAM file for each SRA-SRR id, merge them to generate a single sorted BAM file
	- Use the sorted BAM files with multiple transcript assemblers for genome guided transcript assembly:
		* Trinity GG
		* Class2
		* StringTie
		* Cufflinks
	- Align Trinity transcripts to the genome to generate GFF3 file (using GMAP)
	- Run PortCullis to remove invalid splice junctions
	- Consolidate transcripts and generate a non-redundant set of transcripts using Mikado.
	- Predict ORFs on these consolidated transcripts using TransDecoder
	- run BLASTx for consolidated transcripts against SwissProt curated dataset.
	- Pick best transcripts using all the above information with Miakdo Pick.

4. BIND
	- Combine BRAKER generated predictions with Evidence predictions using EVM.

5. MIND
	- Combine MAKER generated predictions with Evidence predictions using EVM.



## Steps in detail

### 1. Finding Orphan Enriched RNAseq dataset form NCBI:

Go to [NCBI SRA](https://www.ncbi.nlm.nih.gov/sra) page and search with "SRA Advanced Search Builder". This allows you to build a query and select the Runs that satisfy certain requirements. For example:

```
("Arabidopsis thaliana"[Organism] AND
  "filetype fastq"[Filter] AND
	"paired"[Layout] AND
	"illumina"[Platform] AND
	"transcriptomic"[Source])
```

Then export the results to "Run Selector" as follows:

![SRA results](Assets/ncbi-sra.png)

Clicking the "Accession List" should allow you to download all the SRR ids in a text file format. We can use this for downloading data with SRA toolkit (use [`runSRAdownload.sh`](scripts/runSRAdownload.sh))

```bash
while read line; do
	runSRAdownload.sh $line;
done<SRR_Acc_List.txt
```
Note: depending on how much data you find, this can take a lot of time as well as resources (disk usage). Use caution and narrow down to only most interesting datasets, if you can. Also, note that the max size of the SRA is set to 100Gb in this script. If you have a SRA greater than 100Gb, please edit the script to allow those files to download.


Download the CDS sequences for your organism, if available. **If you don't have one, you can skip this step (move to BRAKER step) and use the subset of SRRs for the predictions**.

```
#CDS
wget https://www.arabidopsis.org/download_files/Genes/Araport11_genome_release/Araport11_blastsets/Araport11_genes.201606.cds.fasta.gz
gunzip Araport11_genes.201606.cds.fasta.gz
kallisto index -i ARAPORT11cds Araport11_genes.201606.cds.fasta
```


For each SRR id, run the Kallisto qualitification ([`runKallisto.sh`](scripts/runKallisto.sh)).

```bash
while read line; do
	runKallisto.sh ARAPORT11cds $line;
done<SRR_Acc_List.txt
```
Once done, the tsv files containing counts and TPM were merged using [`joinr.sh`](scripts/joinr.sh):

```bash
joinr.sh *.tsv >> kallisto_out_tair10.txt
```

For every SRR id, the file contains 3 columns, `effective length`, `estimated counts` and `transcript per million`.

Run Phylostratr to identify orphan genes. For running phylostratR program, you need predicted proteins from your gene-prediction method (input).
Once you have the input, run the [`runPhylostrarRa.sh`](scripts/runPhylostratR.sh). This will download the datasets, but will not run BLAST.
Run Blast using [`runBLASTp.sh`](scripts/runBLASTp.sh) and proceed with formatting the BLAST results using [`format-BLAST-for-phylostratr.sh`](scripts/format-BLAST-for-phylostratr.sh).
After which run the [`runPhylostratRb.sh`](scripts/runPhylostratRb.sh).


Once we have the orphan genes identified, total number of orphan genes expressed in each SRR is counted and SRR's are ranked based on number of orphan genes found (>1TPM). Top 38 SRR's is selected (based on total data size), for use with gene prediction in the next steps.


## Run BRAKER

To simplify handling of files, we will combine all the forward reads to one file and all the reverse reads to another.

```bash
cat *_1.fastq.gz >> forward_reads.fq.gz
cat *_2.fastq.gz >> reverse_reads.fq.gz
```

Run BRAKER using the [`runBRAKER.sh`](scripts/runBRAKER.sh) script

```bash
runBraker.sh forward_reads.fq.gz reverse_reads.fq.gz TAIR10_chr_all.fas
```

## Run MAKER

For running MAKER, you will need:


1. Genome assembly in fasta format, eg: `TAIR10_chr_all.fas `
2. Trinity assembled transcripts form the SRA datasets, eg: `trinity.fasta`
3. Trinity transcripts translated to proteins, combined with curated proteins dataset, eg:`trinity-swissprot-pep.fasta`

Here are the steps in detail. generate the CTL files:

```
module load GIF/maker
module rm perl/5.22.1
maker -CTL
```

Edit them to make changes. For the first round, change these lines in `maker_opts.ctl` file:

```
genome=TAIR10_chr_all.fas #genome sequence (fasta file or fasta embeded in GFF3 file)
est=trinity.fasta #set of ESTs or assembled mRNA-seq in fasta format
protein=trinity-swissprot-pep.fasta  #protein sequence file in fasta format (i.e. from mutiple oransisms)
est2genome=1 #infer gene predictions directly from ESTs, 1 = yes, 0 = no
protein2genome=1 #infer predictions from protein homology, 1 = yes, 0 = no
TMP=/dev/shm #specify a directory other than the system default temporary directory for temporary files
```

Execute MAKER in a slurm file as shown, requesting more than 1 node with multiple processors is essential to run this efficiently.

```
/work/GIF/software/programs/mpich2/3.2/bin/mpiexec
  -n 64 \
	/work/GIF/software/programs/maker/2.31.9/bin/maker \
	-base maker \
	-fix_nucleotides
```

Upon completion, train SNAP, AUGUSUTS and Pre-trained GeneMark to run the second round using [script](../scripts/maker_process.sh)

```bash
/maker_process.sh maker
runGeneMark.sh TAIR10_chr_all.fas
```


Once complete, second round MAKER is run by modifying these lines in `maker_opts.ctl` file:


```
#-----Gene Prediction
snaphmm=maker.snap.hmm #SNAP HMM file
gmhmm=/work/LAS/mash-lab/arnstrm/20170320_ArabidopsosGenePrediction_as/04_maker/common_files/gmhmm.mod #GeneMark HMM file
augustus_species=maker_20171103  #Augustus gene prediction species model
```

and run MAKER as:

```bash
/work/GIF/software/programs/mpich2/3.2/bin/mpiexec -n 64 /work/GIF/software/programs/maker/2.31.9/bin/maker -base maker -fix_nucleotides
```

finalize perdictions using [`maker_finalize.sh`](../scripts/maker_finalize.sh) script.

```bash
maker_finalize.sh maker
```
