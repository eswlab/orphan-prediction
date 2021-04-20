======================================================================
Direct Inference evidence-based predictions
======================================================================

**See the scripts used for Direct Inference prediction** `here`_ **.**

**We provide an** `automated pipeline`_ **using snakemaker and pyrpipe.**

**If you have difficulty to install any software for Direct inference prediction, we suggest you to download the** `singularity container`_ **for this step. This container includes all tools required to run the pipeline.**

To use the container, add ``singularity run --cleanenv evidence.sif`` before the tools in each script. For example:

.. code-block:: bash
    :linenos:

    singularity run --cleanenv evidence.sif hisat2


Do RNA-Seq alignment by Hisat2
-------------------------------

.. code-block:: bash
    :linenos:

    while read line; do
	  ./01_runHisat2.sh ${line} TAIR10_chr_all.fas;
    done < SRR_Acc_List.txt

*Note: Cufflinks and Class2 may takes a long time to process BAM file with deep depth region. Better to generate single bam file for each RNA-Seq data for next step.*

Run Transcriptome assemblies using Class2, Cufflinks and Stringtie
-------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    while read line; do
	     ./02_runClass2.sh ${line}_sorted.bam;
	     ./03_runCufflinks.sh ${line}_sorted.bam;
	     ./04_runStringtie.sh ${line}_sorted.bam;
     done < SRR_Acc_List.txt

*Note: Class2, Cufflinks and StringTie generates a gtf format transcripts for each SRR sample. You can use more transcriptome assembler as you need.*

Generate high confidence splice sites
--------------------------------------

.. code-block:: bash
    :linenos:

    ./05_runPortCullis.sh TAIR10_rnaseq.bam

*Note: The merged bam file (* ``TAIR10_rnaseq.bam`` *) obtained from the process of braker. You can also provide multiple single bam files got from* `01_runHisat2.sh` *, but it takes some time to merge bam files. It's faster to provide merged bam if you already run braker.*

Here generate bed and tab file in ``portcullis_out/3-filt``, we only use bed file.

Consolidate all the transcripts, and predict potential protein coding sequence
-------------------------------------------------------------------------------

1. Make a configure file and prepare transcripts:

   You should prepare a ```list.txt`` as below to include gtf path (1st column), gtf abbrev (2nd column), stranded-specific or not (3rd column):

   .. code-block:: bash
       :linenos:

       SRRID1_class.gtf    cs_SRRID1    False
       SRRID1_cufflinks.gtf cl_SRRID1     False
       SRRID1_stringtie.gtf st_SRRID1    False
       SRRID2_class.gtf    cs_SRRID2    False
       SRRID2_cufflinks.gtf cl_SRRID2     False
       SRRID2_stringtie.gtf st_SRRID2    False
       ...

   Then run the script as below:

   .. code-block:: bash
       :linenos:

       ./06_runMikado_round1.sh TAIR10_chr_all.fas junctions.bed list.txt DI

   This will generate ``DI_prepared.fasta`` file that will be used for predicting ORFs in the next step.

| 2. Predict potential CDS from transcripts:

   .. code-block:: bash
       :linenos:

       ./07_runTransDecoder.sh DI_prepared.fasta

   We will use ``DI_prepared.fasta.transdecoder.bed`` in the next step.

   *Note: Here we only kept complete CDS for next step. You can revise* ``07_runTransDecoder.sh`` *to use both incomplete and complete CDS if you need.*

| 3. Pick best transcripts for each locus and annotate them as gene:

   .. code-block:: bash
       :linenos:

       ./08_runMikado_round2.sh DI_prepared.fasta.transdecoder.bed DI

   This will generate:

   .. code-block:: bash
       :linenos:

       mikado.metrics.tsv
       mikado.scores.tsv
       DI.loci.gff3


Optional: Filter out transcripts with redundant CDS
----------------------------------------------------

.. code-block:: bash
    :linenos:

    ./09_rm_redundance.sh DI.loci.gff3 TAIR10_chr_all.fas


Optional: Filter out transcripts whose predicted proteins mapped to transposon elements
-----------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    ./10_TEsorter.sh filter.pep.fa DI.loci.gff3


*Note:* ``filter.pep.fa`` *is an output from previous step for removing redundant CDSs. You can also use all protein sequence if you don't want to remove redundant CDSs.*


.. _here: https://github.com/eswlab/orphan-prediction/tree/master/scripts/DirectInf
.. _singularity container: https://github.com/aseetharam/transcript-assemblers
.. _automated pipeline: https://github.com/eswlab/orphan-prediction/tree/master/evidence_based_pipeline
