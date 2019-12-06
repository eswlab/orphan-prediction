# Orphan gene prediction and optimization

## Downloading datasets

### SRA datasets

Scripts for downloading various datasets from NCBI-SRA/GEO

* [script](scripts/fetch-small-dataset-from-ncbi.sh) to download small dataset.
* [script](scripts/fetch-medium-dataset-from-ncbi.sh) to download medium dataset.
* [script](scripts/fetch-large-dataset-from-ncbi.sh) to download large dataset.
* [script](scripts/create-pooled-dataset.sh) to create pooled dataset.
* [script](scripts/create-pooled-dataset.sh) to download orphan enriched dataset.

### Genomes

```bash
wget https://www.arabidopsis.org/download_files/Genes/TAIR10_genome_release/TAIR10_chromosome_files/TAIR10_chr_all.fas
```

### Other files


```bash
#CDS
wget https://www.arabidopsis.org/download_files/Genes/Araport11_genome_release/Araport11_blastsets/Araport11_genes.201606.cds.fasta.gz
#cDNA
wget https://www.arabidopsis.org/download_files/Genes/Araport11_genome_release/Araport11_blastsets/Araport11_genes.201606.cdna.fasta.gz

# following protein datasets were downloaded from phytozome via Globus
cat Athaliana_167_TAIR10.protein.fa.gz \
	Alyrata_107_v1.0.protein.fa.gz >> proteins_phytozome_arab_2.fa.gz
cat Creinhardtii_281_v5.5.protein.fa.gz \
	Osativa_323_v7.0.protein.fa.gz \
	Ppatens_318_v3.3.protein.fa.gz \
	Cgrandiflora_266_v1.1.protein.fa.gz \
	Sitalica_312_v2.2.protein.fa.gz \
	BrapaFPsc_277_v1.3.protein.fa.gz \
	Gmax_275_Wm82.a2.v1.protein.fa.gz \
	Ptrichocarpa_210_v3.0.protein.fa.gz \
	Alyrata_107_v1.0.protein.fa.gz \
	Athaliana_167_TAIR10.protein.fa.gz >> proteins_phytozome_selected10.fa.gz
```



## Gene Prediction methods and datasets used

All prediction scenarios are listed below. Please follow the respective links to find methods for that prediction scenario.

| Title                                       | DatasetName                         | transcripts                                     | proteins                              | shortname                       | LongName                                                                          |
|---------------------------------------------|-------------------------------------|-------------------------------------------------|---------------------------------------|---------------------------------|-----------------------------------------------------------------------------------|
| [Araport11]                                   | NA                                  | NA                                              | NA                                    | AP11                            | Current version of A. thaliana annotation                                         |
| [MAKER-case1](maker-case1/README.md)                                 | pooled                              | RNAseq assembled                                |                                       | Pool                            | Maker pooled dataset (assembled transcripts only)                                 |
| [MAKER-case2](maker-case2/README.md)                                 | pooled                              | RNAseq assembled                                | phytozome cloesly related spp         | Pool+Phy                        | Maker pooled dataset (transcripts  and phytozome proteins)                        |
| [MAKER-case3](maker-case3/README.md)                                 | Araport11                           | CDS from araport11                              |                                       | Annotated transcripts           | Maker using ARAPORT 11 transcripts as evidence                                    |
| [MAKER-case4](maker-case4/README.md)                                 | Araport11                           | CDS from araport11                              | peptide from araport11                | Annotated transcripts+prots     | Maker using ARAPORT 11 transcripts and proteins as evidence                       |
| [MAKER-case5](maker-case5/README.md)                                 | small                               | RNAseq assembled                                | translated from assembled transcripts | small+tran                      | Maker small dataset (assembled transcripts and its translated proteins)           |
| [MAKER-case6](maker-case6/README.md)                                 | Pooled                              | RNAseq assembled                                | translated from assembled transcripts | Pool+tran                       | Maker pooled dataset (assembled transcripts and its translated proteins)          |
| [MAKER-Orph38](maker-orph38/README.md)                                |                                     | RNAseq assembled                               | translated from assembled transcripts | Maker-Special38                 | Maker with 38 RNAseq libraries (assembled transcripts and translated proteins)    |
| [Braker-S](braker-S/README.md)                                    | small                               | RNAseq aligned to genome                        |                                       | small-raw                       | Braker small dataset (raw RNA-Seq)                                                |
| [Braker-M](braker-M/README.md)                                    | medium                              | RNAseq aligned to genome                        |                                       | med-raw                         | Braker Medium dataset (raw RNA-Seq)                                               |
| [Braker-L](braker-L/README.md)                                    | large                               | RNAseq aligned to genome                        |                                       | large-raw                       | Braker Large dataset (raw RNA-Seq)                                                |
| [Braker-X](braker-X/README.md)                                    | pooled                              | RNAseq aligned to genome                        |                                       | pooled-raw                      | Braker pooled dataset (raw RNA-Seq)                                               |
| [Braker-ap11](braker-ap11/README.md)                                 | Araport11                           | CDS from araport11                              |                                       | actual                          | Braker predictions using ARAPORT11 actual CDS sequences                           |
| [Braker-Orph38](braker-orph38/README.md)                               | Filtered SRA dataset (38 libraries) | RNAseq aligned to genome                        |                                       | Braker-Special38                | Braker with 38 RNAseq libraries (raw RNAseq)                                      |
| [Mikiado-Orph38]()                              |                                     | RNAseq assembled                                | ORF predicted and translated          | Inference-special38             | Mikado with 38 RNAseq libraries                                                   |
| [Mikado-pooled]()                               |                                     | assembled transcripts using multiple assemblers | ORF predicted and translated          | inference-pooled                | Mikado using pooled dataset                                                       |
| OrphanEnriched (Braker+Mikado)              |                                     | assembled transcripts using multiple assemblers | ORF predicted and translated          | Inference-special+Braker-pooled | Mikad with 38 RNAseq libraries + polished with BRAKER orphan enriched predictions |
| OrphanEnriched (Maker+Mikado)               |                                     | assembled transcripts using multiple assemblers | ORF predicted and translated          | Inference-special+Maker-pooled  | Mikad with 38 RNAseq libraries + polished with Maker orphan enriched predictions  |
| Braker \w Pooled + Mikado \w OrphanEnriched |                                     | assembled transcripts using multiple assemblers | ORF predicted and translated          | Inference-special+Maker-pooled  | Mikad with 38 RNAseq libraries + polished with BRAKER pooled predictions          |



## Files for MAKER

Both MAKER and MIKADO requires many files in order to run the predictions. Following methods were used for generating them:


### GeneMark

GeneMark was trained using [`genemark.sub`](scripts/genemark.sub) script. The output file `gmhmm.mod` was used with MAKER predictions.


### Trintiy assembly:

For RNAseq dataset with single-end reads only, [`runTrinityS.sh`](scripts/runTrinityS.sh) was used. For all the other reads, [`runTrinity.sh`](scripts/runTrinity.sh) was used.
The generated assemblies were used as EST evidence for running MAKER

### TransDecoder Predicted proteins

The trinity generated assemblies were used for ORF prediction and for generating translated proteins form the predicted ORFs using [`runTransDecoder.sh`](scripts/runTransDecoder.sh)


### Predicted proteins from closely related spp

These proteins were downloaded from Phytozome website, using Globus and were combined to make 2 datasets as described above. The files generated are:

```
proteins_phytozome_selected10.fa.gz
proteins_phytozome_arab_2.fa.gz
```

## Preparing files for Mikado

Transcriptome assemblies, transdecoder predicted ORFs, BLAST XML files, Portcullis files are required for Mikado and were generated as follows:


1. RNAseq mapping: [`runHisat2.sh`](scripts/runHisat2.sh)
2. Transcriptome assemblies:
	- [`runTrinity-gg.sh`](scripts/runTrinity-gg.sh)
	- [`runClass2.sh`](scripts/runClass2.sh)
	- [`runCufflinks.sh`](scripts/runCufflinks.sh)
	- [`runStringtie.sh`](scripts/runStringtie.sh)
4. GFF file for Trinity transcritps: [`runGMAP_on_Trinity-gg.sh`](scripts/runGMAP_on_Trinity-gg.sh)
5. PortCullis: [`runPortCullis.sh`](scripts/runPortCullis.sh)
6. After these files, you will run the Mikado program to consolidate transcritps/gff3 files (using [`runMikado.sh`](scripts/runMikado.sh)). The other scripts needed for this to run are:
	- TransDecoder: [`runTransDecoder.sh`](scripts/runTransDecoder.sh)
	- BLAST: [`runBLASTx.sh`](scripts/runBLASTx.sh)


## Running Phylostratr

For running phylostratR program, you need predicted proteins from your gene-prediction method (input). 
Once you have the input, run the [`runPhylostrarRa.sh`](scripts/runPhylostratR.sh). This will download the datasets, but will not run BLAST.
Run Blast using [`runBLASTp.sh`](scripts/runBLASTp.sh) and proceed with formatting the BLAST results using [`format-BLAST-for-phylostratr.sh`](scripts/format-BLAST-for-phylostratr.sh).
After which run the [`runPhylostratRb.sh`](scripts/runPhylostratRb.sh).


## Comparing Predictions:

Predictions were compared to Arabidopsis Araport11 predictions using Mikado compare using the [`runMikadoCompare.sh`](scripts/runMikadoCompare.sh).







