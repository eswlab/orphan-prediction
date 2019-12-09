#!/usr/bin/env Rscript
library(UpSetR)
library(ggplot2)
filename <- "orphans_upsetR-main2.csv"
my_data <- read.csv(filename, sep=",", quote='', stringsAsFactors=TRUE, header=TRUE)
p <- upset (my_data,
            nsets = 8, 
            matrix.color = "tomato", 
            main.bar.color = "orangered", 
            mainbar.y.label = "Number of genes", 
            sets.bar.color = "violetred", 
            sets.x.label = "Orphans predicted", 
            point.size = 2.2,
            line.size = 0.7,
            mb.ratio = c(0.7, 0.3), 
            order.by = c("freq", "degree"), 
            decreasing = c(T, F),
            show.numbers = "yes", 
            group.by = "degree",
            shade.color = "tomato",
            shade.alpha = 0.25,
            matrix.dot.alpha = 0.5,
            scale.intersections = "identity",
            scale.sets = "identity"  )
png("upset-main.png", width = 8, height = 8, units = 'in', res = 600)
p
dev.off()


#            empty.intersections = "no",
