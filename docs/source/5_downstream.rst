===============================================================
Downstream analysis for Evaluating predictions
===============================================================


**See the scripts used for downstream evaluation** `here`_ **.**

| 1. Run ``Mikado Compare`` to compare prediction with known annotation

| 2. Run ``Salmon`` to quantify predictions

| 3. Run ``Ribotricer`` to verify translation signal for predicted protein coding genes

| 4. Run ``BUSCO`` to see how well the conserved genes are represented in your final predictions

| 5. Run ``OrthoFinder`` to find and annotate orthologs present in your predictions

| 6. Run ``phylostratR`` to find orphan genes in your predictions [For theory and details, see: https://doi.org/10.1093/bioinformatics/btz171]

| 7. You can also add functional annotation to your genes using homology and ``InterProScan`` (We didn't have this step in our paper).



.. _here: https://github.com/eswlab/orphan-prediction/tree/master/scripts/downstream
