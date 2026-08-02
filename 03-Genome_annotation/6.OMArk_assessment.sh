#!/bin/bash
set -euo pipefail

PROTEIN="Ksch.pep.fa"
LUCA_DB="LUCA.h5"

OMAMER_OUT="Ksch.LUCA.omamer"
OMARK_OUT="Ksch_OMArk_LUCA"

THREADS=8

omamer search \
    -d "${LUCA_DB}" \
    -q "${PROTEIN}" \
    -o "${OMAMER_OUT}" \
    -t "${THREADS}" \
    --log_level info

omark \
    -f "${OMAMER_OUT}" \
    -d "${LUCA_DB}" \
    -o "${OMARK_OUT}" \
    -of "${PROTEIN}" \
    -v
