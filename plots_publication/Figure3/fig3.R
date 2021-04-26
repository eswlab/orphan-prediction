library(tidyr)
library(ggplot2)

all_wide <-read.table("figure2_ps.csv",header=T,sep=",")
all_long <- gather(all_wide,Method,PC,MAKER_small:BIND_orphan,factor_key=TRUE)
all_long$ps <- factor(all_long$ps, levels=c("Arabidopsis thaliana", "Arabidopsis", "Camelineae", "Brassicaceae", "Malvids", "Rosids", "Pentapetalae", "Mesangiospermae", "Magnoliophyta", "Tracheophyta", "Embryophyta", "Streptophytina", "Streptophyta", "Viridiplantae", "Eukaryota", "Cellular Organisms"))
p <- ggplot(all_long[1:144,], aes(x = ps, y = PC, fill = ps)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(ncol = 3, ~ Method) +
  scale_fill_manual(values=c("#D4322F", "#B32DF5", "#F6C245", "#469CAE", "#2254D4", "#E46D2F", "#58C1F1", "#54308B", "#EE8948", "#3C8A43", "#A9C85E", "#53B634", "#D75AC9", "#7B17F4", "#2620D4", "#9D1D88")) +
  coord_flip() +
  ylim(0, 100) +
  labs(x = "Phylostrata", y = "Percent genes matching Araport11 annotations") +
  theme(axis.title.x=element_text(size=20),
        axis.title.y=element_text(size=20),
        legend.position = "none",
        plot.title = element_text(hjust = 0.5, size=16),
        axis.text.y = element_text(face = "italic", size=16),
        axis.text.x = element_text(size=16),
        strip.text = element_text(size = 14))
p
ggsave("figure2.1.newcolor.jpg", p, width = 12, height = 12)

p <- ggplot(all_long[145:208,], aes(x = ps, y = PC, fill = ps)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(ncol = 2, ~ Method) +
  scale_fill_manual(values=c("#D4322F", "#B32DF5", "#F6C245", "#469CAE", "#2254D4", "#E46D2F", "#58C1F1", "#54308B", "#EE8948", "#3C8A43", "#A9C85E", "#53B634", "#D75AC9", "#7B17F4", "#2620D4", "#9D1D88")) +
  coord_flip() +
  ylim(0, 100) +
  labs(x = "Phylostrata", y = "Percent genes matching Araport11 annotations") +
  theme(axis.title.x=element_text(size=20),
        axis.title.y=element_text(size=20),
        legend.position = "none",
        plot.title = element_text(hjust = 0.5, size=16),
        axis.text.y = element_text(face = "italic", size=16),
        axis.text.x = element_text(size=16),
        strip.text = element_text(size = 14))
p
ggsave("figure2.2.newcolor.jpg", p, width = 9, height = 8)
