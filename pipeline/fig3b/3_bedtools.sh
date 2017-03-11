#!/usr/bin/env bash

HOME=/vol3/home/bryans/projects/collab/sclafani
PLOTS=$HOME/20160203/featureplots/orc1mcm2/early_rep

# Map the mean CC  signal to the timing window

bedtools map -a $HOME/raghu.timing.bedgraph -b $PLOTS/cdc7kd_RPM.bg -c 4 -o mean -null "NA" > $PLOTS/cdc7kd_maptiming.bg

bedtools map -a $HOME/raghu.timing.bedgraph -b $PLOTS/cdc7kd_cterm_RPM.bg -c 4 -o mean -null "NA" > $PLOTS/cdc7kd_cterm_maptiming.bg

bedtools map -a $HOME/raghu.timing.bedgraph -b $PLOTS/gal4_RPM.bg -c 4 -o mean -null "NA" > $PLOTS/gal4_maptiming.bg

