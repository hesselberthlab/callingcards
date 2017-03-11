# Set directory in R
setwd('/vol3/home/bryans/projects/collab/sclafani/20160203/featureplots/orc1mcm2/slop5kbcent/early_rep')

# Load df and ID columns 4
ORC1feature <- read.table(('grouped_ORC1.bed'), col.names=c('window', 'CC.signal', 'position', 'sample'))

# Load libraries in R
library(dplyr)
library(reshape2)
library(ggplot2)
library(Cairo)

# Load color palette
sbcolor <- c("#e41a1c", "#377eb8", "#4daf4a", "#ff7f00", "#984ea3", "#f781bf", "#000000")

# Change df to wide format

ORC1feature <- mutate(ORC1feature, CC.signal = as.numeric(as.character(CC.signal)))
ORC1featurew <- dcast(ORC1feature, position ~ sample, value.var="CC.signal")

# Plot Signal vs. Position and color-code samples
# USE THIS
ggplot(ORC1featurew, aes(x=position, group=1)) +
  geom_line(aes(y=cdc7kd, color="cdc7kd"), size=0.5) +
  geom_point(aes(y=cdc7kd), color=sbcolor[1], size=2) +
  geom_line(aes(y=cdc7kd_cterm, color="cdc7kd_cterm"), size=0.5) +
  geom_point(aes(y=cdc7kd_cterm), color=sbcolor[2], size=2) +
  geom_line(aes(y=gal4, color="gal4"), size=0.5) +
  geom_point(aes(y=gal4), color=sbcolor[3], size=2) +
  theme_bw() + scale_color_manual("", breaks = c("cdc7kd", "cdc7kd_cterm", "gal4"), values = c("#e41a1c", "#377eb8", "#4daf4a")) +
  ggtitle('Calling Card Signal vs. ORC1 Binding Sites') +
  xlab('Distance from ORC1 Binding Sites (bp)') +
  ylab('Calling Card Signal (RPM)')

ggsave('CC_vs_ORC1_5kbcentered_EARLY.pdf', height = 8.5, width = 11)



