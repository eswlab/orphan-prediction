=====================
Evaluate predictions
=====================


**See the scripts used for downstream evaluation** `here`_ **.**

| 1. Run ``BUSCO`` to see how well the conserved genes are represented in your final predictions.

| 2. Run ``OrthoFinder`` to find and annotate orthologs present in your predictions.

| 3. Run ``phylostratR`` to infer the phylostratra of the genes in your predictions.  [For theory and details, see: https://doi.org/10.1093/bioinformatics/btz171]

| 4. Add functional annotation to your genes using homology and ``InterProScan``.

  5. Evaluate transcription evidence using Ribo-Seq data.


.. _here: https://github.com/eswlab/orphan-prediction/tree/master/scripts/downstream
