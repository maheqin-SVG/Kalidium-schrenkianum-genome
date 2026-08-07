#!/bin/bash
set -euo pipefail

GENOME=$1
HIFI=$2
PREFIX=Ksch

mkdir -p GC_depth

# Map PacBio HiFi reads to the organelle-filtered assembly
minimap2 -ax map-hifi -t 16 ${GENOME} ${HIFI} | \
    samtools view -bh -F 2308 -q 20 - | \
    samtools sort -@ 8 -o GC_depth/${PREFIX}.HiFi.q20.bam

samtools index GC_depth/${PREFIX}.HiFi.q20.bam
samtools faidx ${GENOME}

# Generate non-overlapping 10-kb windows
cut -f1,2 ${GENOME}.fai > GC_depth/${PREFIX}.genome.sizes

bedtools makewindows \
    -g GC_depth/${PREFIX}.genome.sizes \
    -w 10000 \
    > GC_depth/${PREFIX}.10kb.bed

# Calculate mean HiFi sequencing depth
bedtools coverage \
    -a GC_depth/${PREFIX}.10kb.bed \
    -b GC_depth/${PREFIX}.HiFi.q20.bam \
    -mean \
    > GC_depth/${PREFIX}.10kb.depth.bed

# Calculate GC content
bedtools nuc \
    -fi ${GENOME} \
    -bed GC_depth/${PREFIX}.10kb.bed \
    > GC_depth/${PREFIX}.10kb.nuc.tsv

awk 'BEGIN{OFS="\t"}
NR>1 {print $1,$2,$3,$5*100}' \
    GC_depth/${PREFIX}.10kb.nuc.tsv \
    > GC_depth/${PREFIX}.10kb.GC.bed

# Combine GC content and sequencing depth
echo -e "Chr\tStart\tEnd\tMean_depth\tGC_percent" \
    > GC_depth/${PREFIX}.10kb.GC_depth.tsv

paste \
    GC_depth/${PREFIX}.10kb.depth.bed \
    GC_depth/${PREFIX}.10kb.GC.bed | \
awk 'BEGIN{OFS="\t"} {print $1,$2,$3,$4,$8}' \
    >> GC_depth/${PREFIX}.10kb.GC_depth.tsv


