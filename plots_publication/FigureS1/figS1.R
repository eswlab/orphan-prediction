# tpm file is too large, we cannot put it in github.
# For each prediction, we made expression plot based on the gene whether match to Araport11
# Since the data is too large, we only plot genes in 3 stratam and split plot each age, then merge in powerpoint

maker_tpm <- read.table("maker_tpm.tsv",sep="\t")

# Plot for matched genes
# Sort the genes by the total expression in all samples, and then sort the samples separately for each gene

maker_1 <- maker_tpm[maker_tpm$ps=="cellular_organisms" & maker_tpm$match_ara11==T],]
maker_1$sum <- apply(maker_1[,-(1:3)],1,sum)
maker_1_sort <- maker_1[order(maker_1[,5214],decreasing=T),]
maker_1_sort <- t(apply(maker_1_sort[,4:5213],1,function(x) sort(x,decreasing = T)))


maker_2 <- maker_tpm[maker_tpm$ps=="Magnoliophyta" & maker_tpm$match_ara11==T],]
maker_2$sum <- apply(maker_2[,-(1:3)],1,sum)
maker_2_sort <- maker_2[order(maker_2[,5214],decreasing=T),]
maker_2_sort <- t(apply(maker_2_sort[,4:5213],1,function(x) sort(x,decreasing = T)))


maker_3 <- maker_tpm[maker_tpm$ps=="Arabidopsis_thaliana" & maker_tpm$match_ara11==T],]
maker_3$sum <- apply(maker_3[,-(1:3)],1,sum)
maker_3_sort <- maker_3[order(maker_3[,5214],decreasing=T),]
maker_3_sort <- t(apply(maker_3_sort[,4:5213],1,function(x) sort(x,decreasing = T)))


maker_1_wid <- 10000/nrow(maker_tpm)*nrow(maker_1_sort)
maker_2_wid <- 10000/nrow(maker_tpm)*nrow(maker_2_sort)
maker_3_wid <- 10000/nrow(maker_tpm)*nrow(maker_3_sort)

png(filename="maker_ps1_match.png",width=3000,height=maker_1_wid)
par(mar=c(0,0,0,0))
image(t(maker_1_sort[nrow(maker_1_sort):1,1:5210]),
      col = c("gray95",rev(heat.colors(4)),"maroon"), breaks=c(0,0.78,2.88,8.28,25.26,100,9.8e5),
      axes=F, useRaster=T)
box()
dev.off()


png(filename="maker_ps2_match.png",width=3000,height=maker_2_wid)
par(mar=c(0,0,0,0))
image(t(maker_2_sort[nrow(maker_2_sort):1,1:5210]),
      col = c("gray95",rev(heat.colors(4)),"maroon"), breaks=c(0,0.78,2.88,8.28,25.26,100,9.8e5),
      axes=F, useRaster=T)
box()
dev.off()


png(filename="maker_ps3_match.png",width=3000,height=maker_3_wid)
par(mar=c(0,0,0,0))
image(t(maker_3_sort[nrow(maker_3_sort):1,1:5210]),
      col = c("gray95",rev(heat.colors(4)),"maroon"), breaks=c(0,0.78,2.88,8.28,25.26,100,9.8e5),
      axes=F, useRaster=T)
box()
dev.off()

# Plot for novel genes

maker_1 <- maker_tpm[maker_tpm$ps=="cellular_organisms" & maker_tpm$match_ara11==F],]
maker_1$sum <- apply(maker_1[,-(1:3)],1,sum)
maker_1_sort <- maker_1[order(maker_1[,5214],decreasing=T),]
maker_1_sort <- t(apply(maker_1_sort[,4:5213],1,function(x) sort(x,decreasing = T)))


maker_2 <- maker_tpm[maker_tpm$ps=="Magnoliophyta" & maker_tpm$match_ara11==F],]
maker_2$sum <- apply(maker_2[,-(1:3)],1,sum)
maker_2_sort <- maker_2[order(maker_2[,5214],decreasing=T),]
maker_2_sort <- t(apply(maker_2_sort[,4:5213],1,function(x) sort(x,decreasing = T)))


maker_3 <- maker_tpm[maker_tpm$ps=="Arabidopsis_thaliana" & maker_tpm$match_ara11==F],]
maker_3$sum <- apply(maker_3[,-(1:3)],1,sum)
maker_3_sort <- maker_3[order(maker_3[,5214],decreasing=T),]
maker_3_sort <- t(apply(maker_3_sort[,4:5213],1,function(x) sort(x,decreasing = T)))


maker_1_wid <- 10000/nrow(maker_tpm)*nrow(maker_1_sort)
maker_2_wid <- 10000/nrow(maker_tpm)*nrow(maker_2_sort)
maker_3_wid <- 10000/nrow(maker_tpm)*nrow(maker_3_sort)

png(filename="maker_ps1_novel.png",width=3000,height=maker_1_wid)
par(mar=c(0,0,0,0))
image(t(maker_1_sort[nrow(maker_1_sort):1,1:5210]),
      col = c("gray95",rev(heat.colors(4)),"maroon"), breaks=c(0,0.78,2.88,8.28,25.26,100,9.8e5),
      axes=F, useRaster=T)
box()
dev.off()


png(filename="maker_ps2_novel.png",width=3000,height=maker_2_wid)
par(mar=c(0,0,0,0))
image(t(maker_2_sort[nrow(maker_2_sort):1,1:5210]),
      col = c("gray95",rev(heat.colors(4)),"maroon"), breaks=c(0,0.78,2.88,8.28,25.26,100,9.8e5),
      axes=F, useRaster=T)
box()
dev.off()


png(filename="maker_ps3_novel.png",width=3000,height=maker_3_wid)
par(mar=c(0,0,0,0))
image(t(maker_3_sort[nrow(maker_3_sort):1,1:5210]),
      col = c("gray95",rev(heat.colors(4)),"maroon"), breaks=c(0,0.78,2.88,8.28,25.26,100,9.8e5),
      axes=F, useRaster=T)
box()
dev.off()
