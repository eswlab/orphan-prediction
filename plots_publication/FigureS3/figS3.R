# Upset plot for orphan genes predicted by orphan-rich dataset for yeast
orphan <- read.table("orphan.txt",sep="\t",header=T,stringsAsFactors = F)
orphan <- orphan[,c(1,4,3,5,6,2)]

method <- colnames(orphan)[2:6]
p <- upset(orphan, method, name="Prediction Method",
           width_ratio = 0.4, stripes='white', sort_intersections = F, sort_sets= F,
           intersections=list(
             c('SGD','maker','DI','BIND','MIND'),
             c('SGD','DI','BIND','MIND'),
             c('SGD','maker','BIND','MIND'),
             c('SGD','DI','BIND'),
             c('SGD','maker','MIND'),
             c('SGD','maker'),
             c('SGD','MIND'),
             'SGD',
             c('maker','DI','BIND','MIND'),
             c('DI','BIND','MIND'),
             c('maker','MIND')
           ),
           base_annotations = list(
             'Intersection size'=intersection_size(counts = F)
             + scale_fill_manual(values=c('bars_color'='dimgrey'), guide='none')
#             + annotate(
#               geom='text', x=Inf, y=Inf,
#               label=paste('Total:', nrow(orphan)),
#               vjust=1, hjust=1
#             )
             + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                     panel.background = element_blank(), axis.line = element_line(colour = "black"))

           ),

           themes=upset_default_themes(text=element_text(size=15))
)

png("upset_orphan.png", width = 8, height = 4, units = 'in', res = 600)
p
dev.off()


# Upset plot for orphan genes predicted by pooled dataset for yeast
pool <- read.table("pool.txt",sep="\t",header=T,stringsAsFactors = F)
pool <- pool[,c(1,4,3,5,6,2)]
method <- colnames(pool)[2:6]

p <- upset(pool,method, name="Prediction Method",
           width_ratio = 0.4, stripes='white', sort_intersections = F, sort_sets= F,
           intersections=list(
             c('SGD','maker','DI','BIND','MIND'),
             c('SGD','DI','BIND','MIND'),
             c('SGD','maker','BIND','MIND'),
             c('SGD','DI','BIND'),
             c('SGD','maker','MIND'),
             c('SGD','maker'),
             c('SGD','MIND'),
             'SGD',
             c('maker','DI','BIND','MIND'),
             c('DI','BIND','MIND'),
             c('maker','MIND')
           ),
           base_annotations = list(
             'Intersection size'=intersection_size(counts = F)
             + scale_fill_manual(values=c('bars_color'='dimgrey'), guide='none')
#             + annotate(
#               geom='text', x=Inf, y=Inf,
#               label=paste('Total:', nrow(pool)),
#               vjust=1, hjust=1
#             )
             + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                     panel.background = element_blank(), axis.line = element_line(colour = "black"))

           ),

           themes=upset_default_themes(text=element_text(size=15)),


)

png("upset_pool.png", width = 7.5, height = 4, units = 'in', res = 600)
p
dev.off()


# Upset plot for orphan genes predicted by small dataset for yeast
small <- read.table("small.txt",sep="\t",header=T,stringsAsFactors = F)
small <- small[,c(1,3,5,4,2)]
method <- colnames(small)[2:5]

p <- upset(small,method, name="Prediction Method",
           width_ratio = 0.4, stripes='white', sort_intersections = F, sort_sets= F,
           intersections=list(
             c('SGD','maker','DI'),
             c('SGD','DI'),
             c('SGD','maker'),
             'SGD',
             c('braker','maker'),
             'DI',
             'maker'
           ),
           base_annotations = list(
             'Intersection size'=intersection_size(counts = F)
             + scale_fill_manual(values=c('bars_color'='dimgrey'), guide='none')
#             + annotate(
#               geom='text', x=Inf, y=Inf,
#               label=paste('Total:', nrow(small)),
#               vjust=1, hjust=1
#             )
             + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                     panel.background = element_blank(), axis.line = element_line(colour = "black"))

           ),

           themes=upset_default_themes(text=element_text(size=15)),


)

png("upset_small.png", width = 5.5, height = 4, units = 'in', res = 600)
p
dev.off()
