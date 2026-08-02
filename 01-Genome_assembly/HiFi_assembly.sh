#!/bin/bash
set -euo pipefail
# ------------------------------------------------------------
# 1. Input files and parameters
# ------------------------------------------------------------
HIFI_BAM="Ksch.hifi_reads.bam"
HIFI_FASTA="Ksch.hifi_reads.fasta"
PREFIX="Ksch.asm"
THREADS=20
# ------------------------------------------------------------
# 2. Convert PacBio HiFi BAM to FASTA
# ------------------------------------------------------------
samtools view "${HIFI_BAM}" |
awk '{
    print ">"$1
    print $10
}' > "${HIFI_FASTA}"
# ------------------------------------------------------------
# 3. De novo assembly using hifiasm
# ------------------------------------------------------------
hifiasm \
    -o "${PREFIX}" \
    -t "${THREADS}" \
    "${HIFI_FASTA}" \
    2> "${PREFIX}.log"
# ------------------------------------------------------------
# 4. Convert primary-contig GFA to FASTA
# ------------------------------------------------------------

awk '/^S/{
    print ">"$2
    print $3
}' \
"${PREFIX}.bp.p_ctg.gfa" \
> "${PREFIX}.bp.p_ctg.fa"
# ------------------------------------------------------------
# 5. Index the primary assembly
# ------------------------------------------------------------

samtools faidx "${PREFIX}.bp.p_ctg.fa"
