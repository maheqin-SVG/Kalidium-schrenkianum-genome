#!/bin/bash
set -euo pipefail
GENOME="out_JBAT.FINAL.Ksch.fa"
LINEAGE="embryophyta_odb12.2"
OUT="busco_output_ksch"
THREADS=16

busco \
    -i "${GENOME}" \
    -o "${OUT}" \
    -l "${LINEAGE}" \
    -m genome \
    -c "${THREADS}"

find "${OUT}" \
    -type f \
    -name "short_summary*.txt" \
    -exec cat {} \; \
    > Ksch.BUSCO.full_summary.txt
