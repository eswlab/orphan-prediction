# Gene prediction and optimization using BIND and MIND workflows:

## Overview of MIND and BIND:

Ab initio gene predictions are combined with gene predictions that are Inferred Directly from alignment of RNA-Seq evidence. For MIND, ab initio gene predictions by MAKER  are combined with gene predictions that are Inferred Directly from evidence.
For BIND, ab initio gene predictions by BRAKER are combined with gene predictions that are Inferred Directly from evidence.

1. Find an Orphan-Enriched RNA-Seq dataset from NCBI-SRA:
	- Search RNA-Seq datasets for your organism on NCBI, filter Runs (SRR) for Illumina, paired-end, HiSeq 2500 or newer.
	- Download Runs from NCBI (SRA-toolkit)
	- If existing annotations is available, expression quantification is done against every gene using every SRR with Kallisto.
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
	- Download SwissProt curated proteins (use proteins from Viridiplantae for plants)
	- Run MAKER with transcripts (Trinity), proteins (TransDecoder and SwissProt), in homology-only mode
	- Use the MAKER predictions to train SNAP and AUGUSTUS. Self-train GeneMark
	- Run second round of MAKER with the above (SNAP, AUGUSTUS, and GeneMark) ab initio predictions plus the results from previous MAKER rounds.

3. Run Direct Inference evidence-based predictions:
	- Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
	- Generate BAM file for each SRA-SRR id, merge these to generate a single BAM file sorted by coordinates.
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

![SRA results](Assets/ncbi-sra.png)

Clicking the "Accession List" should allow you to download all the SRR ids in a text file format. We can use this for downloading data with SRA toolkit (use [`runSRAdownload.sh`](scripts/runSRAdownload.sh))

```bash
while read line; do
	runSRAdownload.sh $line;
done<SRR_Acc_List.txt
# max file size is set to 100Gb
# change `--max-size 100G` to allow >100Gb files
```

Note: depending on how much data you find, this can take a lot of time as well as resources (disk usage). You may need to narrow down to select only subset of total datasets. One way to do this is by selecting the most interesting SRRs (eg: stress response RNAseq, flowering tissue RNAseq, etc). In this workflow, we will screen them based on number of orphan genes expressed in each SRR. This assumes that you have existing annotations for your organism. If you don't, then you can skip the next few steps and move to "Run BRAKER" section.

Download the CDS sequences for your organism

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

### Run phylostratr to infer phylostrata of genes, and identify orphan genes.

The input to phylostratr is the predicted proteins from your gene-prediction method.
Using this input, run the [`runPhylostrarRa.sh`](scripts/runPhylostratR.sh). This will download the datasets, but will not run BLAST.
Run Blast using [`runBLASTp.sh`](scripts/runBLASTp.sh) and proceed with formatting the BLAST results using [`format-BLAST-for-phylostratr.sh`](scripts/format-BLAST-for-phylostratr.sh).
Run the [`runPhylostratRb.sh`](scripts/runPhylostratRb.sh).


### Select diverse RNA-Seq data

Once the orphan (species-specific) genes are identified, count the total number of orphan genes expressed (>1TPM) in each SRR, rank them based on % orphan expressed. Depending on how much computational resources you have, you can select the top X number of SRRs to use them as evidence for direct inference and as training data.

Note: for _Arabidopsis thaliana_, we used all of the SRRs that expressed over 60% of the orphan genes (=38 SSRs)
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

## Evidence (direct inference) gene models.

The merged BAM file generated for BRAKER can be used here (`merged_SRA.bam`). All transcript assembly programs will use this as input to generate transcripts . If you plant to use more RNAseq data, you can use the [`runHisat2.sh`](scripts/runHisat2.sh) and generate a single, BAM file of mapped RNAseq reads.

Run Transcriptome assemblies using Trinity, Class2, Cufflinks and Stringtie. The scripts  [`runTrinity-gg.sh`](scripts/runTrinity-gg.sh), [`runClass2.sh`](scripts/runClass2.sh),  [`runCufflinks.sh`](scripts/runCufflinks.sh), [`runStringtie.sh`](scripts/runStringtie.sh) can be executed as:

```bash
runTrinity-gg.sh merged_SRA.bam
runClass2.sh merged_SRA.bam
runCufflinks.sh merged_SRA.bam
runStringtie.sh merged_SRA.bam
```

While Class2, Cufflinks and StringTie generates a GFF3 format transcripts, Trinity only outputs transcripts. To generate GFF3 for Trinity, we can map them back to genome using GMAP. The script [`runGMAP_on_Trinity-gg.sh`](scripts/runGMAP_on_Trinity-gg.sh) can be used as:


```bash
runGMAP_on_Trinity-gg.sh Trinity-GG.fasta
```

The mapped reads can them be processed to generate high confidence splice sites that are useful for picking correct transcritps. We use PortCullis [`runPortCullis.sh`](scripts/runPortCullis.sh) for that purpose:

```bash
runPortCullis.sh merged_SRA.bam
```

We will now consolidate all the transcripts, removing redundancy to create input set of transcripts for Mikado. This is done using Mikado prepare [`runMikado-1.sh`](scripts/runMikado-1.sh).

Running this script requires: `list.txt` a file listing all transcript assemblies and weight; `genome.fasta` target genome assembly; `junctions.bed` with splice junctions information.

`list.txt`

```
mergedBAM_class.gtf    cs1    False
mergedBAM_cufflinks.gtf cl1     False
mergedBAM_stringtie.gtf st1     False
mergedBAM_trinity_gg_match_cdna.gff3    tr1     False
```

```bash
runMikado-1.sh genome.fasta junctions.bed list.txt
```

This will generate `mikado_prepared.fasta` file that will be used for predicting ORFs using TransDecoder [`runTransDecoder.sh`](scripts/runTransDecoder.sh) as follows.

```bash
runTransDecoder.sh mikado_prepared.fasta
# output: mikado_prepared.fasta.transdecoder.bed
```

Information regarding full-length gene models can be generated using BLASTx (against the genome itself or against curated SwissPort). Here we use genome [`runBLASTx.sh`](scripts/runBLASTx.sh).

```bash
runBLASTx.sh mikado_prepared.fasta
# output: mikado.blast.xml
```

As a final step, we will pick best transcripts for each locus and annotate them as gene using Mikado pick.

```
runMikado-2.sh
```
This will generate:

```
mikado.loci.metrics.tsv
mikado.loci.scores.tsv
mikado.loci.gff3
```

## MIND (merged **M**AKER with genes **IN**ferred **D**irectly)

To merge `maker-final.gff3` generated by MAKER with direct evidence models `mikado.loci.gff3`, EVM can be used ([`runEVM.sh`](scripts/runEVM.sh)):

For weights:
```
OTHER_PREDICTION	Mikado_loci	2
ABINITIO_PREDICTION	maker	1
```bash
runEVM.sh maker-final.gff3 mikado.loci.gff3 weights.txt
mv EVM.all.gff3 MIND-final.gff3
```

## BIND (merged **B**RAKER with genes **IN**ferred **D**irectly)

To merge `braker-final.gff3` generated by BRAKER with direct evidence models `mikado.loci.gff3`, EVM can be used:
For weights:
```
OTHER_PREDICTION	Mikado_loci	2
ABINITIO_PREDICTION	AUGUSTUS	1
```

```bash
runEVM.sh braker-final.gff3 mikado.loci.gff3 weights.txt
mv EVM.all.gff3 BIND-final.gff3
```
