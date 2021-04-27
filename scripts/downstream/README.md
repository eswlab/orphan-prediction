See documentation here: [![Documentation Status](https://readthedocs.org/projects/orphan-prediction/badge/?version=latest)](https://orphan-prediction.readthedocs.io/en/latest/)

# Downstream analysis for Evaluating predictions

1. Run [`Mikado Compare`](runMikadoCompare.sh) to compare prediction with known annotation

2. Run [`Salmon`](salmon.sh) to quantify predictions

3. Run [`Ribotricer`](ribo_analysis.sh) to verify translation signal for predicted protein coding genes

4. Run [`OrthoFinder`](orthofinder.md) to find and annotate orthologs present in your predictions

5. Run [`phylostratR`](phylostratr.md) to find orphan genes in your predictions

6. You can also add functional annotation to your genes using homology and `InterProScan` (We didn't have this step in our paper).
