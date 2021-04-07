
# Table of Contents
<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Table of Contents](#table-of-contents)
- [Gene prediction and optimization using BIND and MIND workflows:](#gene-prediction-and-optimization-using-bind-and-mind-workflows)
	- [Overview of MIND and BIND:](#overview-of-mind-and-bind)
	- [Steps in detail, with scripts](#steps-in-detail-with-scripts)
	- [1. Finding Orphan Enriched RNAseq dataset form NCBI:](#1-finding-orphan-enriched-rnaseq-dataset-form-ncbi)
- [max file size is set to 100Gb](#max-file-size-is-set-to-100gb)
- [change `--max-size 100G` to allow >100Gb files](#change-max-size-100g-to-allow-100gb-files)
- [CDS](#cds)
		- [Run phylostratr to infer phylostrata of genes, and identify orphan genes.](#run-phylostratr-to-infer-phylostrata-of-genes-and-identify-orphan-genes)
		- [Select diverse RNA-Seq data](#select-diverse-rna-seq-data)
	- [2A. Run BRAKER (for BIND)](#2a-run-braker-for-bind)
	- [2B. Run MAKER (for MIND)](#2b-run-maker-for-mind)
- [process first round results and train SNAP/AUGUSTUS](#process-first-round-results-and-train-snapaugustus)
- [train GeneMark](#train-genemark)
	- [3. Evidence (direct inference) gene models.](#3-evidence-direct-inference-gene-models)
- [output: DI_prepared.fasta.transdecoder.bed](#output-dipreparedfastatransdecoderbed)
	- [4A. MIND final step](#4a-mind-final-step)
- [Final MIND prediction: MIND.loci.gff3](#final-mind-prediction-mindlocigff3)
	- [4B. BIND final step](#4b-bind-final-step)
- [Final BND prediction: BIND.loci.gff3](#final-bnd-prediction-bindlocigff3)

<!-- /TOC -->

# Gene prediction and optimization using BIND and MIND workflows:

## Overview of MIND and BIND:

**MIND**: _ab initio_ gene predictions by **M**AKER combined with gene predictions **IN**ferred **D**irectly from alignment of RNA-Seq evidence to the genome.
**BIND**: _ab initio_ gene predictions by **B**RAKER combined with gene predictions **IN**ferred **D**irectly from alignment of RNA-Seq evidence to the genome.

1. Find an Orphan-Enriched RNA-Seq dataset from NCBI-SRA:
	- Search RNA-Seq datasets for your organism on NCBI, filter Runs (SRR) for Illumina, paired-end, HiSeq 2500 or newer.
	- Download Runs from NCBI (SRA-toolkit)
	- If existing annotations is available, expression quantification is done against every gene using every SRR with Kallisto.
	- run phylostratR on current gene models to infer phylostrata of each gene model
	- Rank the SRRs with highest number of expressed orphans and select feasible amounts of data to work with.

	If NCBI-SRA has no samples for your organism, and you are relying solely on RNA-Seq that you generate yourself, best practice is to maximize representation of all genes by including conditions like reproductive tissues and stresses in which orphan gene expression is high.

 _Pick one of the 2 _ab initio_ predictions below:_

2. A. Run BRAKER
	- Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
	- Generate BAM file for each SRA-SRR id, merge them to generate a single sorted BAM file
	- Run BRAKER

2. B. Run MAKER
	- Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
	- Generate BAM file for each SRA-SRR id, merge them to generate a single sorted BAM file
	- Run Trinity to generate transcriptome assembly using the BAM file
	- Run TransDecoder on Trinity transcripts to predict ORFs and translate them to protein
	- Download SwissProt curated proteins (use proteins from Viridiplantae for plants)
	- Run MAKER with transcripts (Trinity), proteins (TransDecoder and SwissProt), in homology-only mode
	- Use the MAKER predictions to train SNAP and AUGUSTUS. Self-train GeneMark
	- Run second round of MAKER with the above (SNAP, AUGUSTUS, and GeneMark) ab initio predictions plus the results from previous MAKER rounds.

3. Run Direct Inference evidence-based predictions:
	- Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
	- Generate BAM file for each SRA-SRR id
	- For each BAM file, use multiple transcript assemblers for genome guided transcript assembly:
		* Class2
		* StringTie
		* Cufflinks
	- Run PortCullis to remove invalid splice junctions
	- Consolidate transcripts and generate a non-redundant set of transcripts using Mikado.
	- Predict ORFs on these consolidated transcripts using TransDecoder
	- Pick best transcripts using all the above information with Miakdo Pick.

_If you ran BRAKER in step 2, run 4a._

4. A. Merge BRAKER with Direct Inference (BIND)
	- Use Mikado to combine BRAKER-generated predictions with Direct Inference evidence-based predictions.

_If you ran MAKER in step 2, run 4b._

4. B. Merge MAKER with Direct Inference (MIND)
	- Use Mikado to combine MAKER-generated predictions with Direct Inference evidence-based predictions.

6. Evaluate your predictions

   - Run [`BUSCO`](busco.md) to see how well the conserved genes are represented in your final predictions
	 - Run [`OrthoFinder`](orthofinder.md) to find and annotate orthologs present in your predictions
	 - Run [`phylostratR`](phylostratr.md) to find orphan genes in your predictions
	 - Add functional annotation to your genes using homology and `InterProScan`


## Steps in detail, with scripts
All case studies used in the manuscript are listed in the **Table** [**here**](case-studies.md). Additional information can be found by clicking on the case study (methods, parameters and dataset used).  

## 1. Finding Orphan Enriched RNAseq dataset form NCBI:

Go to [NCBI SRA](https://www.ncbi.nlm.nih.gov/sra) page and search with "SRA Advanced Search Builder". This allows you to build a query and select the Runs that satisfy certain requirements. For example:

```
("Arabidopsis thaliana"[Organism] AND
  "filetype fastq"[Filter] AND
	"paired"[Layout] AND
	"illumina"[Platform] AND
	"transcriptomic"[Source])
```

Then export the results to "Run Selector" as follows:

![SRA results](Assets/ncbi-sra-1.png)

Clicking the "Accession List" allows you to download all the SRR IDs in a text file format. For downloading data with SRA Toolkit (use [`runSRAdownload.sh`](scripts/runSRAdownload.sh))

![SRA results](Assets/ncbi-sra-2.png)


```bash
while read line; do
	runSRAdownload.sh $line;
done<SRR_Acc_List.txt
# max file size is set to 100Gb
# change `--max-size 100G` to allow >100Gb files
```

Note: depending on how much data you find, this can take a lot of time and resources (disk usage). You may need to narrow down and select only a subset of total datasets. One way to choose datasets with maximal orphan representation is to select SRRs most likely to be diverse (eg: stress response, flowering tissue, or SRRs with very deep coverage). 
A better way, which we do in this workflow, is to screen runs based on number of known orphan genes expressed in each SRR; however, this method assumes that you have some existing orphan gene annotations for your organism. If you can't screen runs based on number of known orphan genes, then you can skip the next few steps and move to "Run BRAKER" (or "Run MAKER) section.

Download the CDS sequences for your organism

```
#CDS
wget https://www.arabidopsis.org/download_files/Genes/Araport11_genome_release/Araport11_blastsets/Araport11_genes.201606.cds.fasta.gz
gunzip Araport11_genes.201606.cds.fasta.gz
kallisto index -i ARAPORT11cds Araport11_genes.201606.cds.fasta
```


For each SRR ID, run the Kallisto qualitification ([`runKallisto.sh`](scripts/runKallisto.sh)).

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

### Run phylostratr to infer phylostrata of genes, and identify orphan genes.

The input to phylostratr is the predicted proteins from your gene-prediction method.
Using this input, run the [`runPhylostrarRa.sh`](scripts/runPhylostratRa.sh). This will download the datasets, but will not run BLAST.
Run Blast using [`runBLASTp.sh`](scripts/runBLASTp.sh) and proceed with formatting the BLAST results using [`format-BLAST-for-phylostratr.sh`](scripts/format-BLAST-for-phylostratr.sh).
Run the [`runPhylostratRb.sh`](scripts/runPhylostratRb.sh).


### Select diverse RNA-Seq data

Once the orphan (species-specific) genes are identified, count the total number of orphan genes expressed (>1TPM) in each SRR, rank them based on % orphan expressed. Depending on how much computational resources you have, you can select the top X number of SRRs to use them as evidence for direct inference and as training data.

Note: for _Arabidopsis thaliana_, we used all of the SRRs that expressed over 60% of the orphan genes (=38 SSRs)
Note: If you are relying solely on RNA-Seq that you generate yourself, best practice is to maximize representation of all genes by including conditions like reproductive tissues and stresses, in which orphan gene expression is high.


## 2A. Run BRAKER (for BIND)

To simplify handling of files, combine all the forward reads to one file and all the reverse reads to another.

```bash
cat *_1.fastq.gz >> forward_reads.fq.gz
cat *_2.fastq.gz >> reverse_reads.fq.gz
```

Run BRAKER using the [`runBRAKER.sh`](scripts/runBraker.sh) script

```bash
runBraker.sh forward_reads.fq.gz reverse_reads.fq.gz TAIR10_chr_all.fas
```

## 2B. Run MAKER (for MIND)

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

Upon completion, train SNAP, AUGUSTUS and Pre-trained GeneMark to run the second round using [script](../scripts/maker_process.sh)

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

## 3. Evidence (direct inference) gene models.

Cufflinks and Class2 may takes a long time to process BAM file with deep depth region. Instead of using a merged BAM file, single BAM file for each SRR sample generated by  [`runHisat2.sh`](scripts/runHisat2.sh)  is used in multiple transcript assembly programs to generate transcripts. 

Run Transcriptome assemblies using Class2, Cufflinks and Stringtie. The scripts   [`runClass2.sh`](scripts/runClass2.sh),  [`runCufflinks.sh`](scripts/runCufflinks.sh), [`runStringtie.sh`](scripts/runStringtie.sh) can be executed as:

```bash
while read line; do
	./runClass2.sh ${line}_sorted.bam;
	./runCufflinks.sh ${line}_sorted.bam;
	./runStringtie.sh ${line}_sorted.bam;
done < SRR_Acc_List.txt
```

Class2, Cufflinks and StringTie generates a GFF3 format transcripts for each SRR sample.

The mapped reads can them be processed to generate high confidence splice sites that are useful for picking correct transcritps. We use PortCullis [`runPortCullis.sh`](scripts/runPortCullis.sh) for that purpose:

```bash
runPortCullis.sh merged_SRA.bam
```

We will now consolidate all the transcripts, removing redundancy to create input set of transcripts for Mikado. This is done using Mikado prepare [`runMikado_round1.sh`](scripts/runMikado_round1.sh).

Running this script requires: `list.txt` a file listing all transcript assemblies and weight; `genome.fasta` target genome assembly; `junctions.bed` with splice junctions information.

`list.txt`

```
SRRID1_class.gtf    cs_SRRID1    False
SRRID1_cufflinks.gtf cl_SRRID1     False
SRRID1_stringtie.gtf st_SRRID1    False
SRRID2_class.gtf    cs_SRRID2    False
SRRID2_cufflinks.gtf cl_SRRID2     False
SRRID2_stringtie.gtf st_SRRID2    False
...
```

```bash
runMikado_round1.sh genome.fasta junctions.bed list.txt DI
```

This will generate `DI_prepared.fasta` file that will be used for predicting ORFs using TransDecoder [`runTransDecoder2.sh`](scripts/runTransDecoder2.sh) as follows.

```bash
runTransDecoder2.sh DI_prepared.fasta
# output: DI_prepared.fasta.transdecoder.bed
```

As a final step, we will pick best transcripts for each locus and annotate them as gene using Mikado pick.

```
runMikado_round2.sh DI_prepared.fasta.transdecoder.bed DI
```
This will generate:

```
mikado.metrics.tsv
mikado.scores.tsv
DI.loci.gff3
```

## 4A. MIND final step

Merge gene predictions by **M**AKER with gene predictions  **IN**ferred **D**irectly. Here, `maker-final.gff3` generated by MAKER with direct evidence models `DI.loci.gff3`, Mikado can be used in the same way as Step 3, only change the `list.txt`

`list_MIND.txt`
```
maker-final.gff3    mk    False
DI.loci.gff3 DI     False
```

Run Mikado use same scripts as Step 3:

```bash
runMikado_round1.sh genome.fasta junctions.bed list_MIND.txt MIND
runTransDecoder2.sh MIND_prepared.fasta
runMikado-2.sh MIND_prepared.fasta.transdecoder.bed MIND
# Final MIND prediction: MIND.loci.gff3
```

## 4B. BIND final step

Merge gene predictions of **B**RAKER with gene predictions **IN**ferred **D**irectly.
To merge `braker-final.gff3` generated by BRAKER with direct evidence models `DI.loci.gff3`, Mikado can be used in the same way as Step 3, only change the `list.txt`

`list_BIND.txt`
```
braker-final.gff3    br    False
DI.loci.gff3 DI     False
```

Run Mikado use same scripts as Step 3:

```bash
runMikado_round1.sh genome.fasta junctions.bed list_BIND.txt BIND
runTransDecoder2.sh BIND_prepared.fasta
runMikado-2.sh BIND_prepared.fasta.transdecoder.bed BIND
# Final BND prediction: BIND.loci.gff3
```
