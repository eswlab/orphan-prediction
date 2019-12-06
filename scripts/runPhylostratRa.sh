#!/usr/bin/env Rscript
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
weights=uniprot_weight_by_ref()
focal_taxid <- '3702'
strata <-
  uniprot_strata(focal_taxid, from=2) %>%
  strata_apply(f=diverse_subtree, n=5, weights=weights) %>%
  use_recommended_prokaryotes %>%
  add_taxa(c('4932', '9606')) %>%
  uniprot_fill_strata
