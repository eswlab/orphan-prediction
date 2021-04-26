library(ComplexUpset)
library(ggplot2)

express <- read.table("fig5.express.txt", header=T, sep="\t")
method <- colnames(express)[13:18]

# Since the number of genes in all prediction and annotation is much larger than other groups,
# we made two figures (with and without the group for all prediction and annotation),
# and then mannually merged two figures in powerpoint.

p <- upset(express, method, name="Prediction Method", sort_sets= F, max_degree=5,
           width_ratio = 0.1, stripes='white', sort_intersections = F,
           #sort_intersections_by=c('degree'), sort_intersections = 'descending', sort_sets= F,
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
           annotations = list(
             'Strata' = (
               ggplot(mapping = aes(x=intersection, fill=strata))
               + geom_bar(stat='count', position='fill')
               + scale_y_continuous(labels=scales::percent_format())
               + scale_fill_manual(values=c(
                 'Arabidopsis thaliana'='#D4322F', 'Brassicaceae'='#469CAE',
                 'Tracheophyta'='#A9C85E', 'Eukaryota'='#2620D4',
                 'Cellular Organisms'='#9D1D88'
               ))
               + ylab('Strata')
             )
           ),

           base_annotations = list(
             'Intersection size'=intersection_size(
               text_colors = c(on_background = "black",on_bar = "white"),
               mapping = aes(fill='bars_color'),
               text=list(angle=270, vjust=0.5, hjust=1)
             )
             + scale_fill_manual(values=c('bars_color'='dimgrey'), guide='none')
             + annotate(
               geom='text', x=Inf, y=Inf,
               label=paste('Total:', nrow(express)),
               vjust=1, hjust=1
             )
             + theme(panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank())
           ),

           themes=upset_default_themes(text=element_text(size=15)),

           set_sizes=(
             upset_set_size(
               geom=geom_bar(
                 aes(fill=strata, x=group),
                 width=0.8
               )
             )
             + theme(legend.position="none", axis.text.x=element_text(angle=90, size=10))
             + scale_fill_manual(values=c(
               'Arabidopsis thaliana'='#D4322F', 'Brassicaceae'='#469CAE',
               'Tracheophyta'='#A9C85E', 'Eukaryota'='#2620D4',
               'Cellular Organisms'='#9D1D88'
             ))
             + geom_text(aes(label=..count..), hjust=-1.5, stat='count', size=3)
             + theme(axis.text.x=element_text(angle=90))
           )

)

png("upset/newcolor_express_count.png", width = 18, height = 8, units = 'in', res = 600)
p
dev.off()

p <- upset(express, method, name="Prediction Method", sort_sets= F,
           width_ratio = 0.1, stripes='white', sort_intersections = F,
           #sort_intersections_by=c('degree'), sort_intersections = 'descending', sort_sets= F,
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
           annotations = list(
             'Strata' = (
               ggplot(mapping = aes(x=intersection, fill=strata))
               + geom_bar(stat='count', position='fill')
               + scale_y_continuous(labels=scales::percent_format())
               + scale_fill_manual(values=c(
                 'Arabidopsis thaliana'='#D4322F', 'Brassicaceae'='#469CAE',
                 'Tracheophyta'='#A9C85E', 'Eukaryota'='#2620D4',
                 'Cellular Organisms'='#9D1D88'
               ))
               + ylab('Strata')
             )
           ),

           base_annotations = list(
             'Intersection size'=intersection_size(
               text_colors = c(on_background = "black",on_bar = "white"),
               mapping = aes(fill='bars_color'),
               text=list(angle=270, vjust=0.5, hjust=1)
             )
             + scale_fill_manual(values=c('bars_color'='dimgrey'), guide='none')
             + annotate(
               geom='text', x=Inf, y=Inf,
               label=paste('Total:', nrow(express)),
               vjust=1, hjust=1
             )
             + theme(panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank())
           ),

           themes=upset_default_themes(text=element_text(size=15)),

           set_sizes=(
             upset_set_size(
               geom=geom_bar(
                 aes(fill=strata, x=group),
                 width=0.8
               )
             )
             + theme(legend.position="none", axis.text.x=element_text(angle=90, size=10))
             + scale_fill_manual(values=c(
               'Arabidopsis thaliana'='#D4322F', 'Brassicaceae'='#469CAE',
               'Tracheophyta'='#A9C85E', 'Eukaryota'='#2620D4',
               'Cellular Organisms'='#9D1D88'
             ))
             + geom_text(aes(label=..count..), hjust=-1.5, stat='count', size=3)
             + theme(axis.text.x=element_text(angle=90))
           )

)

png("upset/newcolor_express_count6.png", width = 18, height = 8, units = 'in', res = 600)
p
dev.off()
