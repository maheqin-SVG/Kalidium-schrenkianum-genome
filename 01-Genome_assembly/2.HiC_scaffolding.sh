#!/bin/bash
set -euo pipefail
# Input files and parameters
ASSEMBLY="$(pwd)/Ksch.asm.bp.p_ctg.fa"
HIC_L1_R1="Ksch_L1_R1.fq.gz"
HIC_L1_R2="Ksch_L1_R2.fq.gz"
HIC_L2_R1="Ksch_L2_R1.fq.gz"
HIC_L2_R2="Ksch_L2_R2.fq.gz"
HIC_R1="Ksch_HiC_R1.fq.gz"
HIC_R2="Ksch_HiC_R2.fq.gz"
RAW_BAM="$(pwd)/Ksch_HiC.bam"
FILTERED_BAM="$(pwd)/Ksch_HiC.filtered.bam"
HAPHIC="/path/to/HapHiC"
MAP_THREADS=10
FILTER_THREADS=14
# Merge Hi-C sequencing lanes
cat \
    "${HIC_L1_R1}" \
    "${HIC_L2_R1}" \
    > "${HIC_R1}"
cat \
    "${HIC_L1_R2}" \
    "${HIC_L2_R2}" \
    > "${HIC_R2}"
# Build BWA index
bwa index "${ASSEMBLY}"
# Align Hi-C reads and remove PCR duplicates
bwa mem \
    -t "${MAP_THREADS}" \
    -5SP \
    "${ASSEMBLY}" \
    "${HIC_R1}" \
    "${HIC_R2}" |
samblaster |
samtools view \
    -@ "${MAP_THREADS}" \
    -S \
    -h \
    -b \
    -F 3340 \
    -o "${RAW_BAM}" \
    -
# Filter Hi-C alignments
"${HAPHIC}/utils/filter_bam" \
    "${RAW_BAM}" \
    1 \
    --nm 3 \
    --threads "${FILTER_THREADS}" |
samtools view \
    -b \
    -@ "${FILTER_THREADS}" \
    -o "${FILTERED_BAM}" \
    -
# HapHiC chromosome scaffolding
"${HAPHIC}/haphic" pipeline \
    "${ASSEMBLY}" \
    "${FILTERED_BAM}" \
    9 \
    --quick_view
# Generate files for Juicebox manual curation
# Generate Juicebox files
cd 04.build
ln -sf "${ASSEMBLY}" Ksch.asm.bp.p_ctg.fa
samtools faidx Ksch.asm.bp.p_ctg.fa
"${HAPHIC}/utils/juicer" pre \
    -a \
    -q 1 \
    -o out_JBAT \
    "${FILTERED_BAM}" \
    scaffolds.raw.agp \
    Ksch.asm.bp.p_ctg.fa.fai \
    > out_JBAT.log 2>&1
java \
    -Djava.awt.headless=true \
    -Xmx32G \
    -jar "${JUICER_TOOLS}" \
    pre \
    out_JBAT.txt \
    out_JBAT.hic.part \
    <(grep PRE_C_SIZE out_JBAT.log | awk '{print $2" "$3}')
    
mv out_JBAT.hic.part out_JBAT.hic
# Manual curation:
# Open out_JBAT.hic and out_JBAT.assembly in Juicebox,
# manually inspect and correct the scaffolds, and save the
# reviewed assembly as out_JBAT.review.assembly.
# Generate the final chromosome-scale assembly
"${HAPHIC}/utils/juicer" post \
    -o out_JBAT \
    out_JBAT.review.assembly \
    out_JBAT.liftover.agp \
    "${ASSEMBLY}"
# Plot the final Hi-C contact map
"${HAPHIC}/haphic" plot \
    out_JBAT.FINAL.agp \
    "${FILTERED_BAM}"
