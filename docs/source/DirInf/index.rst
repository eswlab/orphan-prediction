======================================================================
Direct Inference evidence-based predictions
======================================================================

Automated pipeline
--------------------

We provide an `automated pipeline`_ using  `pyrpipe`_ and `snakemake`_. This pipeline can be easily configured and executed in an automated manner  (**HIGHLY RECOMMENDED**).

The automated pipeline can be easily scaled on an HPC by executing multiple samples in parallel.
We recommend using this implementation of the pipeline for simplicity of use and reproducibility of results.

The pipeline can easily be modified and shared.  
For additional information see: pyrpipe (bioRxiv 2020.03.04.925818; doi: https://doi.org/10.1101/2020.03.04.925818) and orfipy (https://doi.org/10.1093/bioinformatics/btab090) pipelines.


Direct Inference prediction by steps
-------------------------------------

If you prefer to run the Direct Inference pipeline step by step, the details are explained below.  

.. _automated pipeline: https://github.com/eswlab/orphan-prediction/tree/master/evidence_based_pipeline
.. _pyrpipe: https://github.com/urmi-21/pyrpipe
.. _snakemake: https://snakemake.github.io/

.. toctree::
   :maxdepth: 1

   3_DirInf
