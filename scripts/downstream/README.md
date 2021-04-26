# Downstream analysis for Evaluating predictions

1. Run [`Mikado Compare`](runMikadoCompare.sh) to compare prediction with known annotation

2. Run [`Salmon`](salmon.sh) to quantify predictions

3. Run [`Ribotricer`](ribo_analysis.sh) to verify translation signal for predicted protein coding genes

4. Run [`BUSCO`](busco.md) to see how well the conserved genes are represented in your final predictions

5. Run [`OrthoFinder`](orthofinder.md) to find and annotate orthologs present in your predictions

6. Run [`phylostratR`](phylostratr.md) to find orphan genes in your predictions

7. You can also add functional annotation to your genes using homology and `InterProScan` (We didn't have this step in our paper).
