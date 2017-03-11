# Set directory in R
setwd('/vol3/home/bryans/projects/collab/sclafani/20160203/combined_boxplot')

# Load df and ID columns
grouped_combined <- read.table('grouped_combined.bed', col.names=c('Window', 'Signal', 'Tmax', 'Sample'))

# Load libraries in R
library(plyr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)



# Color
# Remove outiers 
ggplot(grouped_combined, aes(x=Window, y=as.numeric(as.character(Signal))
)) + scale_color_brewer(palette="Set1") +
  geom_boxplot(aes(color=Sample), outlier.shape=NA, size=0.5) + 
  ylim(0,4) + theme_bw() + 
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
  ggtitle('Cdc7 KD Calling Card Data vs. Replication Time') +
  xlab('Replication Timing (5 min Windows)') +
  ylab('Calling Card Signal (RPM)') +
  facet_grid(. ~ Tmax)

ggsave('Combined_boxplot_color_outliersNA.pdf', height = 8.5, width = 11, device = CairoPDF)

