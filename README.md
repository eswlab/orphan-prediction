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


## Comparing the predictions
