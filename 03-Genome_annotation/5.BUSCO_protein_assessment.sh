#!/bin/bash
set -euo pipefail

PROTEIN="Ksch.pep.fasta"
LINEAGE="embryophyta_odb12.2"
OUT="Ksch_BUSCO_protein"
THREADS=32

busco \
    -i "${PROTEIN}" \
    -o "${OUT}" \
    -l "${LINEAGE}" \
    -m proteins \
    -c "${THREADS}"

find "${OUT}" \
    -type f \
    -name "short_summary*.txt" \
    -exec cat {} \; \
    > Ksch.BUSCO.protein.full_summary.txt
