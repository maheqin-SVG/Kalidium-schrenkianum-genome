#!/bin/bash
set -euo pipefail
GENOME="out_JBAT.FINAL.Ksch.fa"
READ1="Ksch.survey.R1.fq.gz"
READ2="Ksch.survey.R2.fq.gz"
GENOME_SIZE=934011618
KMER=21
THREADS=16
MERQURY="/path/to/merqury"
"${MERQURY}/best_k.sh" "${GENOME_SIZE}"
meryl k="${KMER}" count \
    threads="${THREADS}" \
    output Ksch.R1.meryl \
    "${READ1}"
meryl k="${KMER}" count \
    threads="${THREADS}" \
    output Ksch.R2.meryl \
    "${READ2}"
meryl union-sum \
    output Ksch.reads.meryl \
    Ksch.R1.meryl \
    Ksch.R2.meryl
"${MERQURY}/merqury.sh" \
    Ksch.reads.meryl \
    "${GENOME}" \
    Ksch
cat Ksch.qv
cat Ksch.completeness.stats
