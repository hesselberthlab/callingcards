#!/usr/bin/env bash

#BSUB -J Pipeline
#BSUB -o %J.out
#BSUB -e %J.err

HOME=/vol3/home/bryans/projects/collab/sclafani
PROJECTS=$HOME/20160203/cdc7kd
CURRENT=$PROJECTS/nonori

# Make metadata files comparing timing, origin, and excision-seq data
# Change SLOP, W, and -b amount for each run

#SLOP=50
W=20

# 1. Slop origins

#bedtools slop -b 25000 -i $HOME/oridb.confirmed.bed -g $HOME/sacCer1.chrom.sizes > $HOME/slop${SLOP}kb_oridb.bed

# 2. Map average timing

#bedtools map -a $HOME/slop${SLOP}kb_oridb.bed -b $HOME/raghu.timing.bedgraph -c 4 -o mean > $HOME/slop${SLOP}kb_oridb_raghu_timing.bed

# 3. Select timing windows

for TMAX in {15..55..5}; do
     TMIN=$(($TMAX-5))
     awk -v min=$TMIN -v max=$TMAX 'BEGIN{FS="\t"; OFS="\t"} ($4 > min && $4 <= max) {print $1,$2,$3}' $HOME/raghu.timing.bedgraph > $CURRENT/timingwindow_${TMIN}to${TMAX}.bed
done

# 4. Make windows (use variable)

for TMAX in {15..55..5}; do
     TMIN=$(($TMAX-5))
     bedtools makewindows -b $CURRENT/timingwindow_${TMIN}to${TMAX}.bed -n $W -i winnum | bedtools sort -i - > $CURRENT/makewindows_${TMIN}to${TMAX}.bed
done

# 5. Map windows to Calling Card/ChIP-seq data
# VARIABLES - CHANGED FOR EACH RUN 

#DATE='20141021'
#BARCODE='CGATGT_S1'
SAMPLE='cdc7kd'

for TMAX in {15..55..5}; do
     TMIN=$(($TMAX-5))
     bedtools map -a $CURRENT/makewindows_${TMIN}to${TMAX}.bed -b $PROJECTS/${SAMPLE}_RPM.bg -c 4 -o mean -null 0 | bedtools sort -i - > $CURRENT/${SAMPLE}_${TMIN}to${TMAX}.bed
done

# 6. Group by: summary statistics

for TMAX in {15..55..5}; do
     TMIN=$(($TMAX-5))
     sort -t$'\t' -k4,4n $CURRENT/${SAMPLE}_${TMIN}to${TMAX}.bed | bedtools groupby -i - -g 4 -c 5 -o mean > $CURRENT/grouped_${SAMPLE}_${TMIN}to${TMAX}.bed
done

# 7. Add Tmax to each file

# Remove previous file so we don't append to it

rm -f $CURRENT/grouped_${SAMPLE}.bed

for TMAX in {15..55..5}; do
     TMIN=$(($TMAX-5))
     awk -v min=$TMIN -v max=$TMAX 'BEGIN{FS="\t"; OFS="\t"} {print $1,$2,max}' $CURRENT/grouped_${SAMPLE}_${TMIN}to${TMAX}.bed >> $CURRENT/grouped_${SAMPLE}.bed
done

# 8. Plot: facet on timing window

#Rscript $HOME/nonori/grouped_reptiming.R
 



