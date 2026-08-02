#!/bin/bash
set -euo pipefail

PROTEIN="ksch.pep"
FILTERED_PROTEIN="ksch.pep.flt"

SCRIPT_DIR="./scripts"
FASTA_SPLITTER="/path/to/fasta-splitter.pl"
INTERPROSCAN="/path/to/interproscan-5.52-86.0/interproscan.sh"
MAKEBLASTDB="/path/to/ncbi-blast-2.13.0+/bin/makeblastdb"
BLASTP="/path/to/ncbi-blast-2.13.0+/bin/blastp"
DIAMOND="/path/to/diamond"

SWISSPROT_FASTA="uniprot_sprot.fasta"
SWISSPROT_FUNCTION="swiss_prot.fasta.function"
NR_DB="/path/to/nr.dmnd"
KOG_FASTA="kyva"

# Protein sequence filtering
perl "${SCRIPT_DIR}/00.filter.pep.pl" \
    "${PROTEIN}" \
    > "${FILTERED_PROTEIN}"

# InterProScan annotation
mkdir -p 01.split 02.interproscan.out

perl "${FASTA_SPLITTER}" \
    --n-parts 50 \
    --out-dir 01.split \
    "${FILTERED_PROTEIN}"

for i in {01..50}; do
    "${INTERPROSCAN}" \
        -f tsv \
        -i "./01.split/ksch.pep.part-${i}.flt" \
        -o "./02.interproscan.out/ksch.pep.part-${i}.tsv" \
        -iprlookup \
        -goterms \
        -pa \
        -t p
done

cat 02.interproscan.out/ksch.pep.part-*.tsv \
    > 02.interpro.out.tsv

perl "${SCRIPT_DIR}/03.phase.interproscan.pl" \
    02.interpro.out.tsv \
    > 03.phase.interproscan.out

perl "${SCRIPT_DIR}/04.phase.interpro.IPR.pl" \
    03.phase.interproscan.out

cut -f 1 04.phase.interpro.IPR.pl.out | \
    sort -u \
    > InterPro.annotated_genes.txt

# GO annotation
perl "${SCRIPT_DIR}/03.phaseGO.pl" \
    02.interpro.out.tsv \
    > 03.phaseGO.out

cut -f 1 03.phaseGO.out | \
    sort -u \
    > GO.annotated_genes.txt

# Swiss-Prot annotation
"${MAKEBLASTDB}" \
    -in "${SWISSPROT_FASTA}" \
    -dbtype prot \
    -title uniprot_sprot \
    -parse_seqids \
    -out uniprot_sprot \
    -logfile uniprot_sprot.log

"${BLASTP}" \
    -query "${PROTEIN}" \
    -db uniprot_sprot \
    -out swiss-prot.out \
    -evalue 1e-5 \
    -outfmt 7

perl "${SCRIPT_DIR}/func_anno_stat.pl" \
    "${SWISSPROT_FUNCTION}" \
    swiss-prot.out \
    > SwissProt.function_annotation.tsv

cut -f 1 SwissProt.function_annotation.tsv | \
    sort -u \
    > SwissProt.annotated_genes.txt

# NCBI NR annotation
mkdir -p tmp

"${DIAMOND}" blastp \
    --db "${NR_DB}" \
    --query "${FILTERED_PROTEIN}" \
    --out Ksch.nr.out \
    --outfmt 6 \
    --more-sensitive \
    --max-target-seqs 500 \
    --evalue 1e-5 \
    --id 30 \
    --block-size 2.0 \
    --tmpdir ./tmp \
    --index-chunks 1

cut -f 1 Ksch.nr.out | \
    sort -u \
    > NR.annotated_genes.txt

# KOG annotation
"${MAKEBLASTDB}" \
    -in "${KOG_FASTA}" \
    -dbtype prot \
    -title kog \
    -parse_seqids \
    -out kog \
    -logfile kog.log

"${BLASTP}" \
    -query "${PROTEIN}" \
    -db kog \
    -out kog.out \
    -evalue 1e-5 \
    -outfmt 7

cut -f 1 kog.out | \
    grep '^Ksch' | \
    sort -u \
    > KOG.annotated_genes.txt

# KEGG annotation
# Protein sequences were submitted to the KAAS web server.
# The downloaded KO assignment file was saved as query.ko.

grep 'K' query.ko \
    > kegg.out

cut -f 1 kegg.out | \
    sort -u \
    > KEGG.annotated_genes.txt
