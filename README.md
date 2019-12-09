# Gene prediction and optimization using BIND and MIND workflows:

## Overview of MIND and BIND: 

Ab initio gene predictions are combined with gene predictions that are Inferred Directly from alignment of RNA-Seq evidence. For MIND, ab initio gene predictions by MAKER  are combined with gene predictions that are Inferred Directly from evidence. 
For BIND, ab initio gene predictions by BRAKER are combined with gene predictions that are Inferred Directly from evidence. 

1. Find an Orphan-Enriched RNA-Seq dataset from NCBI-SRA:
	- Search RNA-Seq datasets for your organism on NCBI, filter Runs (SRR) for Illumina, paired-end, HiSeq 2500 or newer.
	- Download Runs from NCBI (SRA-toolkit)
	- quantify against current gene models using kallisto @AS unclear
	- run phylostratR on current gene models to infer phylostrata of each gene model
	- Rank the SRRs with highest number of expressed orphans and select feasible amounts of data to work with.
	
	If NCBI-SRA has no samples for your organism, and you are relying solely on RNA-Seq that you generate yourself, best practice is to maximize representation of all genes by including conditions like reproductive tissues and stresses in which orphan gene expression is high.

2. Run BRAKER
	- Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
	- Generate BAM file for each SRA-SRR id, merge them to generate a single sorted BAM file
	- Run BRAKER

2. Run MAKER
	- Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
	- Generate BAM file for each SRA-SRR id, merge them to generate a single sorted BAM file
	- Run Trinity to generate transcriptome assembly using the BAM file
	- Run TransDecoder on Trinity transcripts to predict ORFs and translate them to protein
	- Download SwissProt curated proteins (use proteins from Viridaplantae for plants)
	- Run MAKER with transcripts (Trinity), proteins (TransDecoder and SwissProt), in homology-only mode
	- Use the MAKER predictions to train SNAP and AUGUSTUS. Self-train GeneMark
	- Run second round of MAKER with the above (SNAP, AUGUSTUS, and GeneMark) ab initio predictions plus the results from previous MAKER rounds.

3. Run Direct Inference evidence-based predictions:
	- Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
	- Generate BAM file for each SRA-SRR id, merge these to generate a single BAM file sorted by XXX.@AS HOW SORTED?
	- Use the sorted BAM file with multiple transcript assemblers for genome guided transcript assembly:
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
	- Combine BRAKER-generated predictions with Direct Inference evidence-based predictions using EVM.

5. MIND
	- Combine MAKER-generated predictions with Direct Inference evidence-based predictions using EVM.



## Steps in detail with scripts
NB-specific case studies are here@AS link

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
Note: depending on how much data you find, this can take a lot of time as well as resources (disk usage). You may need to narrow down to only the most interesting@AS? datasets. Also, the max size of the SRA is set to 100Gb in this script. If you have a SRA greater than 100Gb, be sure to edit the script to allow all files to download.


Download the CDS sequences for your organism, if available. **If not, you can skip this step (move to BRAKER step) and use only SRRs @AS? for the predictions**.

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

## Run phylostratr to infer phylostrata of genes, and identify orphan genes. 
The input to phylostratr is the predicted proteins from your gene-prediction method.
Using this input, run the [`runPhylostrarRa.sh`](scripts/runPhylostratR.sh). This will download the datasets, but will not run BLAST.
Run Blast using [`runBLASTp.sh`](scripts/runBLASTp.sh) and proceed with formatting the BLAST results using [`format-BLAST-for-phylostratr.sh`](scripts/format-BLAST-for-phylostratr.sh).
Run the [`runPhylostratRb.sh`](scripts/runPhylostratRb.sh).


## Select diverse RNA-Seq data 
Once the orphan (species-specific) genes are identified, count the total number of orphan genes expressed in each SRR and ranked SSRs based on number of orphan genes found (>1TPM). Select the top SRR's (based on total data size@AS?); use these as evidence for direct inference and as training data. 
Note: for Arabidopsis thaliana, we used all of the SRRs that expressed over 60% of the orphan genes (=38 SSRs)
Note: If you are relying solely on RNA-Seq that you generate yourself, best practice is to maximize representation of all genes by including conditions like reproductive tissues and stresses, in which orphan gene expression is high.


## Run BRAKER

To simplify handling of files, combine all the forward reads to one file and all the reverse reads to another.

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

This will generate 3 CTL files (`maker_opts.ctl`, `maker_bopts.ctl` and `maker_exe.ctl`), you will need to edit them to make changes to the MAKER run.
For the first round, change these lines in `maker_opts.ctl` file:

```
genome=TAIR10_chr_all.fas
est=trinity.fasta
protein=trinity-swissprot-pep.fasta
est2genome=1
protein2genome=1
TMP=/dev/shm
```

Execute MAKER in a slurm file as shown.  It is essential to request more than 1 node with multiple processors to run this efficiently.

```
mpiexec \
	-n 64 \
	/work/GIF/software/programs/maker/2.31.9/bin/maker \
	-base maker \
	-fix_nucleotides
```

Upon completion, train SNAP, AUGUSUTS and Pre-trained GeneMark to run the second round using [script](../scripts/maker_process.sh)

```bash
# process first round results and train SNAP/AUGUSTUS
maker_process.sh maker
# train GeneMark
runGeneMark.sh TAIR10_chr_all.fas
```


Once complete, the second round of MAKER is run by modifying the following lines in `maker_opts.ctl` file:


```
snaphmm=maker.snap.hmm
gmhmm=gmhmm.mod
augustus_species=maker_20171103
```

and run MAKER as:

```bash
mpiexec \
	-n 64
	/work/GIF/software/programs/maker/2.31.9/bin/maker \
	-base maker \
	-fix_nucleotides
```

finalize predictions using [`maker_finalize.sh`](../scripts/maker_finalize.sh) script.

```bash
maker_finalize.sh maker
```
