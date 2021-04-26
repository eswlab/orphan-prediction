# Upset plot for orphan genes predicted by pooled dataset for rice
pool_upset <- read.table("pool.txt",sep="\t",header=T,stringsAsFactors = F)
method <- colnames(pool_upset)[2:7]
p <- upset(pool_upset,method, name="Prediction Method", sort_sets= F, #max_degree=5,
           width_ratio = 0.1, stripes='white', sort_intersections = F, #group_by='degree',
           #sort_intersections_by=c('degree'), sort_intersections = 'descending', sort_sets= F,
           intersections=list(
             c('NCBI','Braker','Maker','DirInf','BIND','MIND'),
             c('NCBI','Braker','Maker','DirInf','BIND'),
             c('NCBI','Braker','Maker','DirInf','MIND'),
             c('NCBI','Braker','Maker','BIND','MIND'),
             c('NCBI','Braker','DirInf','BIND','MIND'),
             c('NCBI','Maker','DirInf','BIND','MIND'),
             c('NCBI','Braker','Maker','DirInf'),
             c('NCBI','Braker','Maker','BIND'),
             c('NCBI','Braker','Maker','MIND'),
             c('NCBI','Braker','DirInf','BIND'),
             c('NCBI','Braker','DirInf','MIND'),
             c('NCBI','Braker','BIND','MIND'),
             c('NCBI','Maker','DirInf','BIND'),
             c('NCBI','Maker','DirInf','MIND'),
             c('NCBI','Maker','BIND','MIND'),
             c('NCBI','DirInf','BIND','MIND'),
             c('NCBI','Braker','Maker'),
             c('NCBI','Braker','DirInf'),
             c('NCBI','Braker','BIND'),
             c('NCBI','Braker','MIND'),
             c('NCBI','Maker','DirInf'),
             c('NCBI','Maker','BIND'),
             c('NCBI','Maker','MIND'),
             c('NCBI','DirInf','BIND'),
             c('NCBI','DirInf','MIND'),
             c('NCBI','BIND','MIND'),
             c('NCBI','Braker'),
             c('NCBI','Maker'),
             c('NCBI','DirInf'),
             c('NCBI','BIND'),
             c('NCBI','MIND'),
             c('NCBI'),
             c('Braker','Maker','DirInf','BIND','MIND'),
             c('Maker','DirInf','BIND','MIND'),
             c('Braker','DirInf','BIND','MIND'),
             c('Braker','Maker','BIND','MIND'),
             c('Braker','Maker','DirInf','BIND'),
             c('DirInf','BIND','MIND'),
             c('Maker','BIND','MIND'),
             c('Braker','BIND','MIND'),
             c('Braker','DirInf','BIND'),
             c('Braker','Maker','BIND'),
             c('Maker','DirInf','BIND'),
             c('Braker','BIND'),
             c('Maker','BIND'),
             c('DirInf','BIND'),
             c('BIND','MIND'),
             'BIND',
             c('Braker','Maker','DirInf','MIND'),
             c('Maker','DirInf','MIND'),
             c('Braker','Maker','MIND'),
             c('Braker','DirInf','MIND'),
             c('Braker','MIND'),
             c('Maker','MIND'),
             c('DirInf','MIND'),
             'MIND',
             c('Braker','Maker','DirInf'),
             c('Braker','DirInf'),
             c('Maker','DirInf'),
             'DirInf',
             c('Braker','Maker'),
             'Braker',
             'Maker'
           ),
           base_annotations = list(
             'Intersection size'=intersection_size(counts = F)
             + scale_fill_manual(values=c('bars_color'='dimgrey'), guide='none')
#             + annotate(
#               geom='text', x=Inf, y=Inf,
#               label=paste('Total:', nrow(pool_upset)),
#               vjust=1, hjust=1
#             )
             + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                     panel.background = element_blank(), axis.line = element_line(colour = "black"))
             + ggtitle("Groups of orphan genes predicted by pool dataset for rice")
           ),

           themes=upset_default_themes(text=element_text(size=15)),

)

png("upset_pool.png", width = 20, height = 5.5, units = 'in', res = 600)
p
dev.off()


# Upset plot for orphan genes predicted by small dataset for rice
small_upset <- read.table("small.txt",sep="\t",header=T,stringsAsFactors = F)
method <- colnames(small_upset)[2:5]
p <- upset(small_upset,method, name="Prediction Method", sort_sets= F, #max_degree=5,
           width_ratio = 0.3, stripes='white', sort_intersections = F, #group_by='degree',
           #sort_intersections_by=c('degree'), sort_intersections = 'descending', sort_sets= F,
           intersections=list(
             c('NCBI','Braker','Maker','DirInf'),
             c('NCBI','Braker','Maker'),
             c('NCBI','Braker','DirInf'),
             c('NCBI','Maker','DirInf'),
             c('NCBI','Braker'),
             c('NCBI','Maker'),
             c('NCBI','DirInf'),
             'NCBI',
             c('Braker','Maker','DirInf'),
             c('Maker','DirInf'),
             c('Braker','DirInf'),
             'DirInf',
             c('Braker','Maker'),
             'Braker',
             'Maker'
           ),
           base_annotations = list(
             'Intersection size'=intersection_size(counts = F)
             + scale_fill_manual(values=c('bars_color'='dimgrey'), guide='none')
#             + annotate(
#               geom='text', x=Inf, y=Inf,
#               label=paste('Total:', nrow(small_upset)),
#               vjust=1, hjust=1
#             )
             + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                     panel.background = element_blank(), axis.line = element_line(colour = "black"),
                     plot.title = element_text(size = 15))
             + ggtitle("Groups of orphan genes predicted by small dataset for rice")
           ),

           themes=upset_default_themes(text=element_text(size=10)),

)

png("upset_small.png", width = 5, height = 4, units = 'in', res = 600)
p
dev.off()
