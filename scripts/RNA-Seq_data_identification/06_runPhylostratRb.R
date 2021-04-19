#!/usr/bin/env Rscript

# Load all packages for phylostratr.
library(devtools)
.libPaths("~/R/x86_64-pc-linux-gnu-library/3.5")
library(phylostratr)
library(reshape2)
library(taxizedb)
library(dplyr)
library(readr)
library(magrittr)
library(ggtree)
library(knitr)

# Make a tree plot for target species.
strata %>% strata_convert(target='all', to='name') %>% sort_strata %>% plot

# Find best hit for each query gene in BLAST result of each target 
strata <- strata_blast(strata, blast_args=list(nthreads=8)) %>% strata_besthits

# Merge besthit from each target to a single object.
results <- merge_besthits(strata)

# Summarise and stratify age for each query gene.
phylostrata <- stratify(results, classify_by_adjusted_pvalue(0.001))
write.csv(phylostrata, "phylostrata_table.csv")

# Optional: Plot a heatmap for each query gene compare to each target sepcies.
plot_heatmaps(results, "heatmaps.pdf", tree=strata@tree, focal_id=focal_taxid)

# Summarize number of query genes in each phylostrata level.
tabled <- table(phylostrata$mrca_name)
write.csv(tabled, "phylostrata_stats.csv")

