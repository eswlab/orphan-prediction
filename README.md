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

Clicking the "Accession List" should allow you to download all the SRR ids in a text file format. We can use this for downloading data with SRA toolkit (use `runSRAdownload.sh`)

```bash
while read line; do
	runSRAdownload.sh $line;
done<SRR_Acc_List.txt
```

Note: depending on how much data you find, this can take a lot of time as well as resources (disk usage). Use caution and narrow down to only most interesting datasets, if you can.
