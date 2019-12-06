#!/usr/bin/env Rscript
library(ggplot2)
input <- read.csv("score-selected.txt", sep="\t", quote='', stringsAsFactors=TRUE, header=TRUE)
input$nF1 <- factor(input$nF1, levels=c("Absent", "1-25", "26-50", "51-75", "76-100"))
input$Method <- factor(input$Method, levels=c("Make-small+trans", "Make-pool+trans", "Brake-small", "Brake-pool", "DirInf-pool", "DirInf-orph", "BIND-orph", "MIND-orph"))
fill <- c("firebrick1", "darkorange1", "gold3", "dodgerblue", "forestgreen")
p <- ggplot() +
geom_bar(aes(y = Counts, x = Method, fill = nF1, width = 0.5 ), data = input, stat="identity") +
scale_y_continuous(name = "Number of Genes",
breaks = seq(0, 28000, 2000),
limits=c(0, 28000)) +
scale_fill_manual(values=fill) +
scale_x_discrete(name = "Prediction Method") +
ggtitle("Nucleotide F1 score distribution for predictions (genes)") +
theme(panel.grid.major = element_line(colour = "#d3d3d3"),
panel.grid.minor = element_blank(),
panel.border = element_blank(),
panel.background = element_blank(),
plot.title = element_text(size = 12, face = "bold"),
axis.title = element_text(face="bold"),
axis.text.x = element_text(colour="black", size = 12, angle = 90, hjust = 0.5), 
axis.text.y = element_text(colour="black", size = 12),
axis.line = element_line(size=0.5, colour = "black"))
png("score_stackedbarplot-main.png", width = 8, height = 10, units = 'in', res = 600)
p
dev.off()

