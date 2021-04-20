=========================
*Ab initio* predictions
=========================

**Pick one of the 2** *ab initio* **predictions below:**

**Run BRAKER**


   - Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
   - Generate BAM file for each SRA-SRR id, merge them to generate a single sorted BAM file
   - Run BRAKER

**Run MAKER**

   - Align RNA-Seq with splice aware aligner (STAR or HiSat2 preferred, HiSat2 used here)
   - Generate BAM file for each SRA-SRR id, merge them to generate a single sorted BAM file
   - Run Trinity to generate transcriptome assembly using the BAM file
   - Run TransDecoder on Trinity transcripts to predict ORFs and translate them to protein
   - Run MAKER with transcripts (Trinity), proteins (TransDecoder and SwissProt), in homology-only mode
   - Use the MAKER predictions to train SNAP and AUGUSTUS. Self-train GeneMark
   - Run second round of MAKER with the above (SNAP, AUGUSTUS, and GeneMark) ab initio predictions plus the results from previous MAKER rounds.

.. toctree::
   :maxdepth: 1

   2.1_braker
   2.2_maker
