#!/bin/bash
set -euo pipefail

SPECIES=("Bvul" "Hara" "Ksch")
declare -A GFF
declare -A GENOME

GFF["Bvul"]="Bvul.gff3"
GFF["Hara"]="Hara.gff3"
GFF["Ksch"]="Ksch.gff3"

GENOME["Bvul"]="Bvul_genome.fasta"
GENOME["Hara"]="Hara_genome.fasta"
GENOME["Ksch"]="Ksch_genome.fasta"

# 1. Prepare BED and CDS files

for sp in "${SPECIES[@]}"; do

    python -m jcvi.formats.gff bed \
        --type=mRNA \
        --key=ID \
        "${GFF[$sp]}" \
        > "${sp}.bed"

    python -m jcvi.formats.bed uniq "${sp}.bed"

    mv "${sp}.uniq.bed" "${sp}.bed"

    gffread \
        "${GFF[$sp]}" \
        -g "${GENOME[$sp]}" \
        -x "${sp}.all.cds.fa"

    seqkit grep \
        -f <(cut -f 4 "${sp}.bed") \
        "${sp}.all.cds.fa" | \
    seqkit seq -i \
        > "${sp}.cds"

done

# 2. Identify pairwise syntenic anchors

python -m jcvi.compara.catalog ortholog \
    --no_strip_names \
    Ksch Bvul

python -m jcvi.compara.catalog ortholog \
    --no_strip_names \
    Hara Bvul

python -m jcvi.compara.catalog ortholog \
    --no_strip_names \
    Hara Ksch

# 3. Filter syntenic blocks

python -m jcvi.compara.synteny screen \
    --minspan=30 \
    --simple \
    Ksch.Bvul.anchors \
    Ksch.Bvul.anchors.new

python -m jcvi.compara.synteny screen \
    --minspan=30 \
    --simple \
    Hara.Ksch.anchors \
    Hara.Ksch.anchors.new

python -m jcvi.compara.synteny screen \
    --minspan=30 \
    --simple \
    Hara.Bvul.anchors \
    Hara.Bvul.anchors.new

# 4. Prepare chromosome order

awk '$1 !~ /Contig/ && !seen[$1]++ {print $1}' \
    Hara.bed | \
paste -sd"," - \
    > Hara.seqids

awk '$1 !~ /Contig/ && !seen[$1]++ {print $1}' \
    Ksch.bed | \
paste -sd"," - \
    > Ksch.seqids

awk '
$1 !~ /Contig/ && !seen[$1]++ {
    chr[++n]=$1
}
END{
    for(i=n;i>=1;i--)
        print chr[i] "-"
}
' Bvul.bed | \
paste -sd"," - \
    > Bvul.seqids

cat \
    Hara.seqids \
    Ksch.seqids \
    Bvul.seqids \
    > all.seqids

# 5. Generate layout and plot chromosome-level synteny

cat > layout <<'EOF'
# y, xstart, xend, rotation, color, label, va, bed
.7, .1, .8, 0, , Hara, top, Hara.bed
.5, .1, .8, 0, , Ksch, top, Ksch.bed
.3, .1, .8, 0, , Bvul, top, Bvul.bed
# edges
e, 0, 1, Hara.Ksch.anchors.simple
e, 1, 2, Ksch.Bvul.anchors.simple
EOF

python -m jcvi.graphics.karyotype \
    all.seqids \
    layout
