#!/usr/bin/env Rscript
library(ggplot2)
theme_set(theme_bw(base_size = 10))

filename <- "all-orphans-freq-gc.tsv"
input <- read.csv(filename, sep="\t", quote='', stringsAsFactors=TRUE, header=TRUE)
input$GC <- factor(input$GC, levels=c("<30", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", ">65"))
input$Method <- factor(input$Method, levels=c("Araport11", "Make-small+trans", "Make-pool+trans", "Brake-small", "Brake-pool", "DirInf-pool", "DirInf-orph", "BIND-orph", "MIND-orph"))
t <- ggplot(input, aes(x= GC, y= counts, color=Method, group=Method)) +
geom_line(size = 1) +
scale_y_continuous(name = "Number of Genes",
breaks = seq(0, 2000, 500),
limits=c(1, 2000)) +
scale_x_discrete(name = "GC (%) Distribution", breaks = input$GC[seq(1, length(input$GC), by = 2)]) +
ggtitle("GC Distribution across different methods") +
theme_bw() +
theme(panel.grid.major = element_line(colour = "#d3d3d3"),
legend.position = c(.95, .95),
legend.text = element_text(size=12), 
legend.justification = c("right", "top"),
legend.box.just = "right",
legend.margin = margin(6, 6, 6, 6),
panel.grid.minor = element_blank(),
panel.border = element_blank(),
panel.background = element_blank(),
plot.title = element_text(size = 12, face = "bold"),
axis.title = element_text(face="bold"),
axis.text.x = element_text(colour="black", size = 12, hjust = 1),
axis.text.y = element_text(colour="black", size = 12),
axis.line = element_line(size=0.5, colour = "black"))
t <- t + geom_point() + scale_color_manual(values=c("gray8", "palevioletred1", "palevioletred3", "olivedrab", "olivedrab2", "slateblue1", "tan1", "royalblue", "red"))
ggsave("all-orphans-freq-gc.png", t, width = 10, height = 8)

filename <- "all-basal-freq-gc.tsv"
input <- read.csv(filename, sep="\t", quote='', stringsAsFactors=TRUE, header=TRUE)
input$GC <- factor(input$GC, levels=c("<30", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", ">65"))
input$Method <- factor(input$Method, levels=c("Araport11", "Make-small+trans", "Make-pool+trans", "Brake-small", "Brake-pool", "DirInf-pool", "DirInf-orph", "BIND-orph", "MIND-orph"))
t <- ggplot(input, aes(x= GC, y= counts, color=Method, group=Method)) +
geom_line(size = 1) +
scale_y_continuous(name = "Number of Genes",
breaks = seq(0, 2000, 500),
limits=c(1, 2000)) +
scale_x_discrete(name = "GC (%) Distribution", breaks = input$GC[seq(1, length(input$GC), by = 2)]) +
ggtitle("GC Distribution across different methods") +
theme_bw() +
theme(panel.grid.major = element_line(colour = "#d3d3d3"),
legend.position = c(.95, .95),
legend.text = element_text(size=12), 
legend.justification = c("right", "top"),
legend.box.just = "right",
legend.margin = margin(6, 6, 6, 6),
panel.grid.minor = element_blank(),
panel.border = element_blank(),
panel.background = element_blank(),
plot.title = element_text(size = 12, face = "bold"),
axis.title = element_text(face="bold"),
axis.text.x = element_text(colour="black", size = 12, hjust = 1),
axis.text.y = element_text(colour="black", size = 12),
axis.line = element_line(size=0.5, colour = "black"))
t <- t + geom_point() + scale_color_manual(values=c("gray8", "palevioletred1", "palevioletred3", "olivedrab", "olivedrab2", "slateblue1", "tan1", "royalblue", "red"))
ggsave("all-basal-freq-gc.png", t, width = 10, height = 8)
