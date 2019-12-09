#!/usr/bin/env Rscript
library(ggplot2)
theme_set(theme_bw(base_size = 18))
filename <- "combined-sensitivity.tsv"
my_data <- read.csv(filename, sep="\t", quote='', stringsAsFactors=TRUE, header=TRUE)
my_data$PS <- factor(my_data$PS, levels=c("Arabidopsis thaliana", "Arabidopsis", "Camelineae", "Brassicaceae", "Malvids", "Rosids", "Pentapetalae", "Mesangiospermae", "Magnoliophyta", "Spermatophyta", "Tracheophyta", "Embryophyta", "Streptophyta", "Viridiplantae", "Eukaryota", "Cellular Organisms"))
my_data$Method <- factor(my_data$Method, levels=c("Make-small+trans", "Make-pool+trans", "Brake-small", "Brake-large", "DirInf-orph", "DirInf-pool", "BIND-orph", "MIND-orph"))
p <- ggplot(my_data, aes(x = PS, y = PC, fill = PS)) +
        geom_bar(stat = "identity", position = "dodge") +
        facet_wrap(ncol = 2, ~ Method) +
        scale_fill_manual(values=c("#8B4513", "#EE7621", "#458B00", "#76EE00", "#5F9EA0", "#8EE5EE", "#8B3E2F", "#FF7256", "#008B8B", "#00CDCD", "#CD6600", "#FF7F00", "#68228B", "#B23AEE", "#CD1076", "#CD2626")) + 
        coord_flip() +
        ylim(0, 100) + 
        labs(x = "Phylostrata", y = "Sensitivity percent for predictions matching Araport11 annotations") +
        theme(axis.title.x=element_text(size=16), 
              axis.title.y=element_text(size=16),
              legend.position = "none",
              plot.title = element_text(hjust = 0.5, size=16),
              axis.text.y = element_text(face = "italic", size=16),
              axis.text.x = element_text(size=16))
ggsave("combined-sensitivity.png", p, width = 10, height = 15)

