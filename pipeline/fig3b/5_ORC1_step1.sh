#!/usr/bin/env bash

#BSUB -J Pipeline
#BSUB -o %J.out
#BSUB -e %J.err

set -o nounset -o pipefail -o errexit -x

HOME=/vol3/home/bryans/projects/collab/sclafani
PROJECTS=$HOME/20160203
PLOTS=/$PROJECTS/featureplots/orc1mcm2/slop5kbcent/early_rep

# 1. Slop TSS

bedtools slop -b 5000 -i $HOME/datafiles/orc1mcm2/ORC_ChIP_chip_NUM.bedgraph -g $HOME/sacCer1.chrom.sizes | bedtools sort -i - > $PLOTS/ORC1_slop.bed

# 2. Make windows around ori's

D=101

bedtools makewindows -b $PLOTS/ORC1_slop.bed -n $D -i winnum | bedtools sort -i - > $PLOTS/windows_ORC1.bed

# 3. Map windows of 42 earliest oris to mean du signal

SAMPLE='gal4'

bedtools map -a $PLOTS/windows_ORC1.bed -b $PLOTS/early_${SAMPLE}_maptiming.bg -c 4 -o mean -null 0 | bedtools sort -i - > $PLOTS/${SAMPLE}_ORC1.bed

# 4. Group by windows for mean for each x value (250bp window)

sort -t$'\t' -k4,4n $PLOTS/${SAMPLE}_ORC1.bed | bedtools groupby -i - -g 4 -c 5 -o mean > $PLOTS/grouped_${SAMPLE}_ORC1.bed

# Add distance from feature column

#awk 'BEGIN{FS="\t"; OFS="\t"} {getline to_add < "1kbposdata.txt"} {print $1,$2,to_add}' $PLOTS/grouped_${SAMPLE}_ORC1.bed > $PLOTS/grouped_${SAMPLE}_ORC1.bed

