#!/usr/bin/env bash

#BSUB -J Pipeline2
#BSUB -o %J.out
#BSUB -e %J.err

set -o nounset -o pipefail -o errexit -x

HOME=/vol3/home/bryans/projects/collab/sclafani
PROJECTS=$HOME/20160203/featureplots

# To outputs from pipeline_earlyoris_step1 (grouped_oriwindows_strain_sample.bg), add sample info and combine into 1 file

# 5. Add Strain/Sample to each file

SAMPLE='gal4'
awk -v sample=$SAMPLE 'BEGIN{FS="\t"; OFS="\t"} {print $1,$2,$3,sample}' $PROJECTS/grouped_${SAMPLE}_TSS.bed > $PROJECTS/grouped_TSS.bed

SAMPLE='cdc7kd'
awk -v sample=$SAMPLE 'BEGIN{FS="\t"; OFS="\t"} {print $1,$2,$3,sample}' $PROJECTS/grouped_${SAMPLE}_TSS.bed >> $PROJECTS/grouped_TSS.bed

SAMPLE='cdc7kd_cterm'
awk -v sample=$SAMPLE 'BEGIN{FS="\t"; OFS="\t"} {print $1,$2,$3,sample}' $PROJECTS/grouped_${SAMPLE}_TSS.bed >> $PROJECTS/grouped_TSS.bed

# 6. Plot: combine data, make new column for sample ID, facet on timing window

#Rscript $PEAKS/ori_norm.R
 



