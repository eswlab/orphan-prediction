# Upset plot for orphan genes predicted by orphan-rich dataset for Arabidopsis
orphan_orphan <- read.table("orphan_orphan.txt", header=T, sep="\t")
method <- colnames(orphan_orphan)[3:8]
p <- upset(orphan_orphan,method, name="Prediction Method",
           width_ratio = 0.1, stripes='white', sort_intersections = F, sort_sets= F,
           intersections=list(
             c('Araport11','Braker','Maker','DirInf','BIND','MIND'),
             c('Araport11','Braker','Maker','DirInf','BIND'),
             c('Araport11','Braker','Maker','DirInf','MIND'),
             c('Araport11','Braker','Maker','BIND','MIND'),
             c('Araport11','Braker','DirInf','BIND','MIND'),
             c('Araport11','Maker','DirInf','BIND','MIND'),
             c('Araport11','Braker','Maker','DirInf'),
             c('Araport11','Braker','Maker','BIND'),
             c('Araport11','Braker','Maker','MIND'),
             c('Araport11','Braker','DirInf','BIND'),
             c('Araport11','Braker','DirInf','MIND'),
             c('Araport11','Maker','DirInf','BIND'),
             c('Araport11','Maker','DirInf','MIND'),
             c('Araport11','DirInf','BIND','MIND'),
             c('Araport11','Braker','Maker'),
             c('Araport11','Braker','DirInf'),
             c('Araport11','Braker','BIND'),
             c('Araport11','Maker','DirInf'),
             c('Araport11','Maker','MIND'),
             c('Araport11','DirInf','BIND'),
             c('Araport11','DirInf','MIND'),
             c('Araport11','Braker'),
             c('Araport11','Maker'),
             c('Araport11','DirInf'),
             c('Araport11','MIND'),
             c('Araport11'),
             c('Braker','Maker','DirInf','BIND','MIND'),
             c('Maker','DirInf','BIND','MIND'),
             c('Braker','DirInf','BIND','MIND'),
             c('Braker','Maker','BIND','MIND'),
             c('Braker','Maker','DirInf','BIND'),
             c('DirInf','BIND','MIND'),
             c('Braker','BIND','MIND'),
             c('Braker','DirInf','BIND'),
             c('Braker','Maker','BIND'),
             c('Braker','BIND'),
             c('Braker','Maker','DirInf','MIND'),
             c('Maker','DirInf','MIND'),
             c('Braker','Maker','MIND'),
             c('Maker','MIND'),
             c('Braker','Maker'),
             'Braker',
             'Maker'
           ),
           base_annotations = list(
             'Intersection size'=intersection_size(counts = F)
             + scale_fill_manual(values=c('bars_color'='dimgrey'), guide='none')
             + annotate(
               geom='text', x=Inf, y=Inf,
               label=paste('Total:', nrow(pool_orphan)),
               vjust=1, hjust=1
             )
             + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                     panel.background = element_blank(), axis.line = element_line(colour = "black"))
             + ggtitle("Groups of orphan genes predicted by pooled dataset")
           ),

           themes=upset_default_themes(text=element_text(size=15)),


)

png("upset_orphan.png", width = 18, height = 5.5, units = 'in', res = 600)
p
dev.off()




# Upset plot for orphan genes predicted by pooled dataset for Arabidopsis
pool_orphan <- read.table("pool_orphan.txt", header=T, sep="\t")
method <- colnames(pool_orphan)[3:8]
p <- upset(pool_orphan,method, name="Prediction Method",
           width_ratio = 0.1, stripes='white', sort_intersections = F, sort_sets= F,
           intersections=list(
             c('Araport11','Braker','Maker','DirInf','BIND','MIND'),
             c('Araport11','Braker','Maker','DirInf','BIND'),
             c('Araport11','Braker','Maker','DirInf','MIND'),
             c('Araport11','Braker','Maker','BIND','MIND'),
             c('Araport11','Braker','DirInf','BIND','MIND'),
             c('Araport11','Maker','DirInf','BIND','MIND'),
             c('Araport11','Braker','Maker','DirInf'),
             c('Araport11','Braker','Maker','BIND'),
             c('Araport11','Braker','Maker','MIND'),
             c('Araport11','Braker','DirInf','BIND'),
             c('Araport11','Braker','DirInf','MIND'),
             c('Araport11','Maker','DirInf','BIND'),
             c('Araport11','Maker','DirInf','MIND'),
             c('Araport11','DirInf','BIND','MIND'),
             c('Araport11','Braker','Maker'),
             c('Araport11','Braker','DirInf'),
             c('Araport11','Braker','BIND'),
             c('Araport11','Maker','DirInf'),
             c('Araport11','Maker','MIND'),
             c('Araport11','DirInf','BIND'),
             c('Araport11','DirInf','MIND'),
             c('Araport11','Braker'),
             c('Araport11','Maker'),
             c('Araport11','DirInf'),
             c('Araport11','MIND'),
             c('Araport11'),
             c('Braker','Maker','DirInf','BIND','MIND'),
             c('Maker','DirInf','BIND','MIND'),
             c('Braker','DirInf','BIND','MIND'),
             c('Braker','Maker','BIND','MIND'),
             c('Braker','Maker','DirInf','BIND'),
             c('DirInf','BIND','MIND'),
             c('Braker','BIND','MIND'),
             c('Braker','DirInf','BIND'),
             c('Braker','Maker','BIND'),
             c('Braker','BIND'),
             c('Braker','Maker','DirInf','MIND'),
             c('Maker','DirInf','MIND'),
             c('Braker','Maker','MIND'),
             c('Maker','MIND'),
             c('Braker','Maker'),
             'Braker',
             'Maker'
           ),
           base_annotations = list(
             'Intersection size'=intersection_size(counts = F)
             + scale_fill_manual(values=c('bars_color'='dimgrey'), guide='none')
             + annotate(
               geom='text', x=Inf, y=Inf,
               label=paste('Total:', nrow(orphan_orphan)),
               vjust=1, hjust=1
             )
             + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                     panel.background = element_blank(), axis.line = element_line(colour = "black"))
             + ggtitle("Groups of orphan genes predicted by pooled dataset")
           ),

           themes=upset_default_themes(text=element_text(size=15)),


)

png("upset_pool.png", width = 18, height = 5.5, units = 'in', res = 600)
p
dev.off()


# Upset plot for orphan genes predicted by small dataset for Arabidopsis
pool_orphan <- read.table("small_orphan.txt", header=T, sep="\t")
method <- colnames(small_orphan)[3:6]
p <- upset(small_orphan,method, name="Prediction Method",
           width_ratio = 0.1, stripes='white', sort_intersections = F, sort_sets= F,
           intersections=list(
             c('Araport11','Braker','Maker','DirInf'),
             c('Araport11','Braker','Maker'),
             c('Araport11','Braker','DirInf'),
             c('Araport11','Maker','DirInf'),
             c('Araport11','Braker'),
             c('Araport11','Maker'),
             c('Araport11','DirInf'),
             'Araport11',
             c('Braker','DirInf'),
             c('Maker','DirInf'),
             'DirInf'
           ),
           base_annotations = list(
             'Intersection size'=intersection_size(counts = F)
             + scale_fill_manual(values=c('bars_color'='dimgrey'), guide='none')
             + annotate(
               geom='text', x=Inf, y=Inf,
               label=paste('Total:', nrow(small_orphan)),
               vjust=1, hjust=1
             )
             + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                     panel.background = element_blank(), axis.line = element_line(colour = "black"))
             + ggtitle("Groups of orphan genes predicted by small dataset")
           ),

           themes=upset_default_themes(text=element_text(size=15)),


)

png("upset_small.png", width = 3, height = 2.5, units = 'in', res = 600)
p
dev.off()
