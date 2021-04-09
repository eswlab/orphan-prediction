#!/usr/bin/env Rscript

# Load all packages for phylostratr
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

# Check the details to use phylostratr at https://github.com/arendsee/phylostratr 
# Define weights to build phylogenetic tree by default for uniprot protein sequence.
# You can also used your own weights. 
weights=uniprot_weight_by_ref()

# NCBI taxid for focal species, here is Arabidopsis thaliana.
focal_taxid <- '3702'

# Build a phylogenetic tree and download protein sequence for each species from uniprot.
# Downloaded protein sequence stored in uniprot-seqs
strata <-
  uniprot_strata(focal_taxid, from=2) %>%
  strata_apply(f=diverse_subtree, n=5, weights=weights) %>%
  use_recommended_prokaryotes %>%
  add_taxa(c('4932', '9606')) %>%
  uniprot_fill_strata
