See documentation here: [![Documentation Status](https://readthedocs.org/projects/orphan-prediction/badge/?version=latest)](https://orphan-prediction.readthedocs.io/en/latest/)

# Downstream analyses that can be used to evaluate gene predictions

1. *Run [`Mikado Compare`](runMikadoCompare.sh) to compare prediction with known annotation

2. *Run [`Salmon`](salmon.sh) to quantify expression levels of predictions across samples. 
    -Can be used as a filter for low expression.
    -Gives information about the conditions under which the predicted gene is expressed.
    -Can be used to cluster predicted genes with genes of known function
    -Can be used in interactive exploratory analyses, e.g., via MetaOmGraph(https://github.com/urmi-21/MetaOmGraph/) to                 hypothesis function

3. *Run [`Ribotricer`](ribo_analysis.sh) to obtain translation evidence for predicted protein coding genes.

4. *Run [`phylostratR`](phylostratr.md) to find the phylostrata of genes in your predictions.

5.  Run [`OrthoFinder`](orthofinder.md) to find and annotate orthologs present in your predictions.

6.  Add functional annotation to your genes using homology and `InterProScan`.  




*Used in this paper.
