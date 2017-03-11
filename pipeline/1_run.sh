#! /usr/bin/env bash

#BSUB -J proc[1-3]
#BSUB -o %J.$I.out
#BSUB -e %J.$I.err

set -o nounset -o pipefail -o errexit -x

BARCODES=(1_CGATGT 2_TTAGGC 3_TGACCA)
BARCODE_IDX=$(($LSB_JOBINDEX - 1))
BARCODE=${BARCODES[$BARCODE_IDX]}

PROJECTS="$HOME/projects/collab/sclafani/20160203"
FASTQ_FILE="$PROJECTS/$BARCODE""_L001_R1_001.fastq.gz"
BOWTIEINDEX="$HOME/ref/genomes/sacCer1/sacCer1"
CHROMSIZES="$HOME/ref/genomes/sacCer1/sacCer1.chrom.sizes"

#BAMPREFIX="$(echo $BARCODE)" | cut -f1 -d'_'
BAMPREFIX=$BARCODE
STDIN="-"
  
zcat $FASTQ_FILE \
    | bowtie -5 17 -m 1 --sam $BOWTIEINDEX $STDIN \
    | samtools view -bS $STDIN > "$BAMPREFIX.unsorted.bam" \
       
samtools sort "$BAMPREFIX.unsorted.bam" -o "$BAMPREFIX.bam"
         
# remove unsorted bam file
rm -f "$BAMPREFIX.unsorted.bam"
            
BEDGRAPH="$BAMPREFIX.bg"
BEDGRAPHPOS="$BAMPREFIX.pos.bg"
BEDGRAPHNEG="$BAMPREFIX.neg.bg"
              
# removed the "-5" flag to look at coverage
bedtools genomecov -ibam "$BAMPREFIX.bam" \
    -bg -5 -g $CHROMSIZES \
    > $BEDGRAPH
bedtools genomecov -ibam "$BAMPREFIX.bam" \
    -bg -strand + -5 -g $CHROMSIZES \
    > $BEDGRAPHPOS
bedtools genomecov -ibam "$BAMPREFIX.bam" \
    -bg -strand - -5 -g $CHROMSIZES \
    > $BEDGRAPHNEG
                       
BIGWIG="$BAMPREFIX.bw"
BIGWIGPOS="$BAMPREFIX.pos.bw"
BIGWIGNEG="$BAMPREFIX.neg.bw"
bedGraphToBigWig $BEDGRAPH $CHROMSIZES $BIGWIG
bedGraphToBigWig $BEDGRAPHPOS $CHROMSIZES $BIGWIGPOS
bedGraphToBigWig $BEDGRAPHNEG $CHROMSIZES $BIGWIGNEG
                                                                                        
