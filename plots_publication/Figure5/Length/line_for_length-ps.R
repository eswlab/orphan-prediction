#!/usr/bin/env Rscript
library(ggplot2)
theme_set(theme_bw(base_size = 12))

filename <- "all-basal-freq-len.tsv"
input <- read.csv(filename, sep="\t", quote='', stringsAsFactors=TRUE, header=TRUE)
library(ggplot2)
input$Length <- factor(input$Length, levels=c("100", "200", "300", "400", "500", "600", "700", "800", "900", "1000", "1100", "1200", "1300", "1400", "1500", "1600", "1700", "1800", "1900", "2000", "2100", "2200", "2300", "2400", "2500", "2600", "2700", "2800", "2900", "3000", "3100", "3200", "3300", "3400", "3500", "3600", "3700", "3800", "3900", "4000", "4100", "4200", "4300", "4400", "4500", "4600", "4700", ">4500"))
input$Method <- factor(input$Method, levels=c("Araport11", "Make-small+trans", "Make-pool+trans", "Brake-small", "Brake-pool", "DirInf-pool", "DirInf-orph", "BIND-orph", "MIND-orph"))
t <- ggplot(input, aes(x= Length, y= Counts, color=Method, group=Method)) +
geom_line(size = 1) +
scale_y_continuous(name = "Number of Genes",
breaks = seq(0, 4000, 500),
limits=c(1, 4000)) +
scale_x_discrete(name = "Length Distribution", breaks = input$Length[seq(1, length(input$Length), by = 4)]) +
ggtitle("Length Distribution across different methods (genes)") +
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
ggsave("all-basal-freq-len.png", t, width = 10, height = 8)

filename <- "all-orphans-freq-len.tsv"
input <- read.csv(filename, sep="\t", quote='', stringsAsFactors=TRUE, header=TRUE)
library(ggplot2)
input$Length <- factor(input$Length, levels=c("100", "200", "300", "400", "500", "600", "700", "800", "900", "1000", "1100", "1200", "1300", "1400", "1500", "1600", "1700", "1800", "1900", "2000", "2100", "2200", "2300", "2400", "2500", "2600", "2700", "2800", "2900", "3000", "3100", "3200", "3300", "3400", "3500", "3600", "3700", "3800", "3900", "4000", "4100", "4200", "4300", "4400", "4500", "4600", "4700", ">4500"))
input$Method <- factor(input$Method, levels=c("Araport11", "Make-small+trans", "Make-pool+trans", "Brake-small", "Brake-pool", "DirInf-pool", "DirInf-orph", "BIND-orph", "MIND-orph"))
t <- ggplot(input, aes(x= Length, y= Counts, color=Method, group=Method)) +
geom_line(size = 1) +
scale_y_continuous(name = "Number of Genes",
breaks = seq(0, 4000, 500),
limits=c(1, 4000)) +
scale_x_discrete(name = "Length Distribution", breaks = input$Length[seq(1, length(input$Length), by = 4)]) +
ggtitle("Length Distribution across different methods (genes)") +
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
ggsave("all-orphans-freq-len.png", t, width = 10, height = 8)


