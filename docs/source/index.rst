BIND and MIND: Gene prediction and optimization
=====================================================

*************
Introduction
*************

**MIND**: *ab initio* gene predictions by **M**\ AKER combined with gene
predictions **IN**\ ferred **D**\ irectly from alignment of RNA-Seq
evidence to the genome. **BIND**: *ab initio* gene predictions by
**B**\ RAKER combined with gene predictions **IN**\ ferred
**D**\ irectly from alignment of RNA-Seq evidence to the genome.


Overview
#########

1. Find an Orphan-Enriched RNA-Seq dataset from NCBI-SRA

2. *Ab initio* gene prediction (BRAKER or MAKER)

3. Direct Inference evidence-based predictions

4. *Ab initio* and Direct Inference evidence-based predictions

5. Evaluate your predictions


*********
Tutorial
*********

**See the detailed scripts** `here`_ **.**

Contents
--------

.. toctree::
   :maxdepth: 1

   1_find_RNA-Seq.rst
   2_abinitio/index.rst
   DirInf/index.rst
   4_merge/index.rst
   5_downstream.rst


Tools used for prediction
#########################

============================= ===========================
Tool                          Purpose
============================= ===========================
`SRA Tools`_ (v. 2.9.6 )      SRA access
`Hisat2`_ (v. 2.2.0)          Alignment
`STAR`_ (v. 2.7.7a)           Alignment
`Kallisto`_ (v. 0.46.2)       Quantification
`Samtools`_ (v. 1.10)         Tools
`CLASS2`_ (v. 2.1.7)          Transcript Assembly
`Stringtie`_ (v. 1.3.3)       Transcript Assembly
`Cufflinks`_ (v. 2.2.1)       Transcript Assembly
`Trinity`_ (v. 2.6.6)         Transcript Assembly
`Porticullis`_ (v. 1.2.2)     Tools
`Transdecoder`_ (v. 3.0.1)    CDS prediction
`Mikado`_ (v. 2.0)            Direct Inference prediction
`Phylostratr`_ (v. 0.2.0)     Phylostratigraphy
`BLAST`_ (v. 3.11.0)          Tools
`Braker`_ (v. 2.1.2)          *Ab initio* prediction
`Maker`_ (v. 2.31.10)         *Ab initio* prediction
`GMAP-GSNAP`_ (v. 2019-05-12) Alignment
`GeneMark`_ (v. 4.83)         *Ab initio* Prediction
============================= ===========================

.. _here: https://github.com/eswlab/orphan-prediction
.. _SRA Tools: https://github.com/ncbi/sra-tools
.. _Hisat2: https://daehwankimlab.github.io/hisat2/
.. _STAR: https://github.com/alexdobin/STAR
.. _Kallisto: https://pachterlab.github.io/kallisto/
.. _Samtools: https://github.com/samtools/samtools
.. _CLASS2: http://ccb.jhu.edu/people/florea/research/CLASS2/
.. _Stringtie: https://github.com/gpertea/stringtie
.. _Cufflinks: http://cole-trapnell-lab.github.io/cufflinks/
.. _Trinity: https://github.com/trinityrnaseq/trinityrnaseq
.. _Porticullis: https://github.com/maplesond/portcullis
.. _Transdecoder: https://github.com/TransDecoder/TransDecoder
.. _Mikado: https://github.com/EI-CoreBioinformatics/mikado
.. _Phylostratr: https://github.com/arendsee/phylostratr
.. _BLAST: https://www.ncbi.nlm.nih.gov/books/NBK279668/
.. _Braker: https://github.com/Gaius-Augustus/BRAKER
.. _Maker: http://www.yandell-lab.org/software/maker-p.html
.. _GMAP-GSNAP: http://research-pub.gene.com/gmap/
.. _GeneMark: http://exon.gatech.edu/GeneMark/
