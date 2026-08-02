#!/bin/bash
set -euo pipefail

GENOME="out_JBAT.FINAL.Ksch.fa"
THREADS=64

EDTA.pl \
    --genome "${GENOME}" \
    --sensitive 1 \
    --anno 1 \
    --threads "${THREADS}"
