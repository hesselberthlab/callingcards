#!/usr/bin/env bash

#BSUB -J Pipeline
#BSUB -o %J.out
#BSUB -e %J.err
#BSUB -m "compute05"
#BSUB -q short


set -o nounset -o pipefail -o errexit -x

HOME=/vol3/home/bryans/projects/collab/sclafani
PROJECTS=$HOME/20160203
PLOTS=/$PROJECTS/featureplots

# 1. Slop TSS

bedtools slop -b 1000 -i $HOME/datafiles/TSS/lee-tss-sacCer1.bed -g $HOME/sacCer1.chrom.sizes | bedtools sort -i - > $PLOTS/TSS_slop.bed

# 2. Make windows around ori's

D=21

bedtools makewindows -b $PLOTS/TSS_slop.bed -n $D -i winnum | bedtools sort -i - > $PLOTS/windows_TSS.bed

# 3. Map windows of 42 earliest oris to mean du signal

SAMPLE='cdc7kd'

bedtools map -a $PLOTS/windows_TSS.bed -b $PROJECTS/norm/${SAMPLE}_RPM.bg -c 4 -o mean -null 0 | bedtools sort -i - > $PLOTS/${SAMPLE}_TSS.bed

# 4. Group by windows for mean for each x value (250bp window)

sort -t$'\t' -k4,4n $PLOTS/${SAMPLE}_TSS.bed | bedtools groupby -i - -g 4 -c 5 -o mean > $PLOTS/grouped_${SAMPLE}_TSS.bed


# Add distance from feature column

awk 'BEGIN{FS="\t"; OFS="\t"} {getline to_add < "1kbposdata.txt"} {print $1,$2,to_add}' $PLOTS/grouped_${SAMPLE}_TSS.bed > $PLOTS/grouped_${SAMPLE}_TSS.bed
