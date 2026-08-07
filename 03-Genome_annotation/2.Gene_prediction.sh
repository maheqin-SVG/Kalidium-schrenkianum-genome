#!/bin/bash
set -euo pipefail
GENOME="out_JBAT.FINAL.Ksch.fa"
RNA_R1="ksch-RNA_stem.r1.fq.gz,ksch-RNA_leaf.r1.fq.gz"
RNA_R2="ksch-RNA_stem.r2.fq.gz,ksch-RNA_leaf.r2.fq.gz"
PROTEIN="homolog.fasta"
PFAM_DB="Pfam-AB.hmm"
CONFIG="GETA_config.txt"
CPU=32

geta.pl \
    --RM_species Viridiplantae \
    --genome "${GENOME}" \
    -1 "${RNA_R1}" \
    -2 "${RNA_R2}" \
    --protein "${PROTEIN}" \
    --augustus_species Ksch \
    --cpu "${CPU}" \
    --out_prefix Ksch \
    --gene_prefix Ksch \
    --config "${CONFIG}" \
    --pfam_db "${PFAM_DB}"
