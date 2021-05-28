library(readr)
library(ggplot2)
library(RColorBrewer)

di_times <- read_delim("di_times.tsv", "\t", escape_double = FALSE, trim_ws = TRUE)

my_palette <- brewer.pal(name="Set1",n=9)[1:8]
mycolors <- colorRampPalette(brewer.pal(8, "Set3"))(11)

ggplot(di_times, aes(fill=Step, y=Time, x=Pipeline_Scenario)) + 
  geom_bar(position="stack", stat="identity")+scale_fill_manual(values = mycolors) +
#+scale_fill_brewer(palette=mycolors)+
  #scale_y_log10()+
  theme(legend.background = element_blank(),
        legend.box.background = element_rect(colour = "black"),
        axis.ticks.x=element_blank(),
        axis.text.x = element_text(size = 12,face = "bold",angle = 0, vjust = 0.5, hjust=0.5), #x axis labels
        axis.text.y = element_text(size = 12,face = "bold",angle = 0, vjust = 0.5, hjust=0), #y axis labels
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(), axis.title=element_text(size=12,face="bold"))+ #the y axis label
  ylab("Walltime(Min.)")+xlab("")+
  xlab("")+
  theme(strip.background = element_blank(),strip.text.x = element_blank(),
        panel.spacing = unit(0.1, "lines"),panel.margin.x=unit(0.1, "lines"),
        panel.spacing.y=unit(1, "lines")
  )
