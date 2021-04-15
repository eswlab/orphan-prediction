
# Table of Contents
<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Table of Contents](#table-of-contents)
- [Gene prediction and optimization using BIND and MIND workflows:](#gene-prediction-and-optimization-using-bind-and-mind-workflows)
    - [Find an Orphan-Enriched RNA-Seq dataset from NCBI-SRA](#1-find-an-orphan-enriched-rna-seq-dataset-from-ncbi-sra-see-details-here)
    - [_Ab initio_ gene prediction](#2-ab-initio-gene-prediction)
    - [Direct Inference evidence-based predictions](#3-direct-inference-evidence-based-predictions-see-details-here)
    - [Combine _ab initio_ and Direct Inference evidence-based predictions](#4-combine-ab-initio-and-direct-inference-evidence-based-predictions)
    - [Evaluate your predictions](#5-evaluate-your-predictions-see-details-here)
- [Tools list](#prediction-tools-include)

<!-- /TOC -->

# Gene prediction and optimization using BIND and MIND workflows:

**MIND**: _ab initio_ gene predictions by **M**AKER combined with gene predictions **IN**ferred **D**irectly from alignment of RNA-Seq evidence to the genome.
**BIND**: _ab initio_ gene predictions by **B**RAKER combined with gene predictions **IN**ferred **D**irectly from alignment of RNA-Seq evidence to the genome.

## 1. Find an Orphan-Enriched RNA-Seq dataset from NCBI-SRA ([See details here](scripts/RNA-Seq_prepare)):
   - Search RNA-Seq datasets for your organism on NCBI, filter Runs (SRR) for Illumina, paired-end, HiSeq 2500 or newer.
   - Download Runs from NCBI (SRA-toolkit)
   - If existing annotations is available, expression quantification is done against every gene using every SRR with Kallisto.
   - run phylostratr on current gene models to infer phylostrata of each gene model
   - Rank the SRRs with highest number of expressed orphans and select feasible amounts of data to work with.

   _Note: If NCBI-SRA has no samples for your organism, and you are relying solely on RNA-Seq that you generate yourself, best practice is to maximize representation of all genes by including conditions like reproductive tissues and stresses in which orphan gene expression is high._

## 2. _Ab initio_ gene prediction:

   _Pick one of the 2 _ab initio_ predictions below:_

   1. Run BRAKER ([See details here](scripts/braker)):
   
      - Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here) 
      - Generate BAM file for each SRA-SRR id, merge them to generate a single sorted BAM file
      - Run BRAKER

   2. Run MAKER ([See details here](scripts/maker)):
      - Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
      - Generate BAM file for each SRA-SRR id, merge them to generate a single sorted BAM file
      - Run Trinity to generate transcriptome assembly using the BAM file
      - Run TransDecoder on Trinity transcripts to predict ORFs and translate them to protein
      - Run MAKER with transcripts (Trinity), proteins (TransDecoder and SwissProt), in homology-only mode
      - Use the MAKER predictions to train SNAP and AUGUSTUS. Self-train GeneMark
      - Run second round of MAKER with the above (SNAP, AUGUSTUS, and GeneMark) ab initio predictions plus the results from previous MAKER rounds.

## 3. Direct Inference evidence-based predictions ([See details here](scripts/DirectInf)):

   ### We provide an automated pipeline for evidence-based predictions ([See details here](evidence_based_pipeline))
   
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
   

## 4. Combine _ab initio_ and Direct Inference evidence-based predictions:
   
   _If you ran BRAKER in step 2, run 4.1_

   1. Merge BRAKER with Direct Inference (BIND) ([See details here](scripts/BIND)):
   
   - Use Mikado to combine BRAKER-generated predictions with Direct Inference evidence-based predictions.

   _If you ran MAKER in step 2, run 4.2_

   2. Merge MAKER with Direct Inference (MIND) ([See details here](scripts/MIND)):
	
   - Use Mikado to combine MAKER-generated predictions with Direct Inference evidence-based predictions.

## 5. Evaluate your predictions ([See details here](scripts/downstream)):

   - Run `BUSCO` to see how well the conserved genes are represented in your final predictions
   - Run `OrthoFinder` to find and annotate orthologs present in your predictions
   - Run `phylostratR` to find orphan genes in your predictions
   - Add functional annotation to your genes using homology and `InterProScan`


## Prediction tools include:

| Tool                                                                                 | Purpose             |
|--------------------------------------------------------------------------------------|---------------------|
| [SRA Tools](https://github.com/ncbi/sra-tools) (v. 2.9.6 )                  | SRA access          |
| [Hisat2](https://daehwankimlab.github.io/hisat2/) (v. 2.2.0)                            | Alignment           |
| [STAR](https://github.com/alexdobin/STAR) (v. 2.7.7a)                                           | Alignment           |
| [Kallisto](https://pachterlab.github.io/kallisto/) (v. 0.46.2)                                  | Quantification      |
| [Samtools](https://github.com/samtools/samtools) (v. 1.10)                                    | Tools               |
| [CLASS2](http://ccb.jhu.edu/people/florea/research/CLASS2/) (v. 2.1.7)                           | Transcript Assembly |
| [Stringtie](https://github.com/gpertea/stringtie) (v. 1.3.3)                                   | Transcript Assembly |
| [Cufflinks](http://cole-trapnell-lab.github.io/cufflinks/) (v. 2.2.1)                           | Transcript Assembly |
| [Trinity](https://github.com/trinityrnaseq/trinityrnaseq) (v. 2.6.6)                           | Transcript Assembly |
| [Porticullis](https://github.com/maplesond/portcullis) (v. 1.2.2)                           | Tools |
| [Transdecoder](https://github.com/TransDecoder/TransDecoder) (v. 3.0.1)                           | CDS prediction |
| [Mikado](https://github.com/EI-CoreBioinformatics/mikado) (v. 2.0)                           | Direct Inference prediction |
| [Phylostratr](https://github.com/arendsee/phylostratr) (v. 0.2.0)                                    | Phylostratigraphy              |
| [BLAST](https://www.ncbi.nlm.nih.gov/books/NBK279668/) (v. 3.11.0)                                    | Tools               |
| [Braker](https://github.com/Gaius-Augustus/BRAKER) (v. 2.1.2)                                    | _Ab initio_ prediction               |
| [Maker](http://www.yandell-lab.org/software/maker-p.html) (v. 2.31.10)                                    | _Ab initio_ prediction               |
| [GMAP-GSNAP](http://research-pub.gene.com/gmap/) (v. 2019-05-12)                                    | Alignment               |
| [GeneMark](http://exon.gatech.edu/GeneMark/) (v. 4.83)                                    | _Ab initio_ Prediction               |

