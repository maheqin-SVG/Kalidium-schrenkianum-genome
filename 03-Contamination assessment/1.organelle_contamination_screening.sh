#!/bin/bash
set -euo pipefail

GENOME=$1
CP=$2
MT=$3
PREFIX=Ksch

mkdir -p organelle_screening

# Align the genome assembly against chloroplast and mitochondrial genomes
minimap2 -x asm5 -t 16 ${CP} ${GENOME} > organelle_screening/${PREFIX}.cp.paf
minimap2 -x asm5 -t 16 ${MT} ${GENOME} > organelle_screening/${PREFIX}.mt.paf

# Convert PAF alignments to BED and merge overlapping regions
for TYPE in cp mt
do
    awk 'BEGIN{OFS="\t"} {print $1,$3,$4}' \
        organelle_screening/${PREFIX}.${TYPE}.paf | \
        sort -k1,1 -k2,2n | \
        bedtools merge -i - \
        > organelle_screening/${PREFIX}.${TYPE}.merged.bed
done

# Calculate organellar alignment coverage for each scaffold
samtools faidx ${GENOME}

for TYPE in cp mt
do
    awk 'BEGIN{OFS="\t"}
         NR==FNR {len[$1]=$2; next}
         {cov[$1]+=$3-$2}
         END {
             for (id in len)
                 if (cov[id]/len[id] >= 0.5)
                     print id
         }' \
        ${GENOME}.fai \
        organelle_screening/${PREFIX}.${TYPE}.merged.bed \
        > organelle_screening/${PREFIX}.${TYPE}.candidate.ids
done

# Combine candidate scaffolds
cat organelle_screening/${PREFIX}.cp.candidate.ids \
    organelle_screening/${PREFIX}.mt.candidate.ids | \
    sort -u \
    > organelle_screening/${PREFIX}.organelle_candidate.ids

# Remove candidate organelle-derived scaffolds
seqkit grep -v \
    -f organelle_screening/${PREFIX}.organelle_candidate.ids \
    ${GENOME} \
    > organelle_screening/${PREFIX}.no_organelle.fa
