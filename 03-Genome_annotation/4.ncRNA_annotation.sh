#!/bin/bash
set -euo pipefail

GENOME="out_JBAT.FINAL.Ksch.fa"

# 1. Rfam/Infernal ncRNA annotation

RFAM_CM="Rfam.cm"
RFAM_CLANIN="Rfam.clanin"
TBLOUT2GFF="/path/to/infernal-tblout2gff.pl"
RFAM_Z=1900

cmpress "${RFAM_CM}"

cmscan \
    -Z "${RFAM_Z}" \
    --cut_ga \
    --rfam \
    --nohmmonly \
    --fmt 2 \
    --tblout Ksch.Rfam.tblout \
    -o Ksch.Rfam.result \
    --clanin "${RFAM_CLANIN}" \
    "${RFAM_CM}" \
    "${GENOME}"

perl "${TBLOUT2GFF}" \
    --cmscan \
    --fmt2 \
    Ksch.Rfam.tblout \
    > Ksch.Rfam.ncRNA.gff3


# 2. tRNA annotation

tRNAscan-SE \
    "${GENOME}" \
    -o Ksch.tRNA.out \
    -f Ksch.tRNA.ss \
    -m Ksch.tRNA.stats


# 3. rRNA annotation

RRNA_DIR="/path/to/rRNA_reference_sequences"
BLAST_DB="Ksch_genome"
IDENTITY=85
THREADS=8

declare -A QUERY
declare -A MINLEN

QUERY["5S"]="${RRNA_DIR}/Sole.5S.fasta"
QUERY["5.8S"]="${RRNA_DIR}/Sole.5.8S.fasta"
QUERY["18S"]="${RRNA_DIR}/Sole.18S.fasta"
QUERY["28S"]="${RRNA_DIR}/Sole.28S.fasta"

MINLEN["5S"]=90
MINLEN["5.8S"]=140
MINLEN["18S"]=150
MINLEN["28S"]=300

makeblastdb \
    -in "${GENOME}" \
    -dbtype nucl \
    -parse_seqids \
    -out "${BLAST_DB}"

for TYPE in 5S 5.8S 18S 28S; do

    blastn \
        -query "${QUERY[$TYPE]}" \
        -db "${BLAST_DB}" \
        -out "Ksch.${TYPE}.rRNA.blast.out" \
        -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore" \
        -evalue 1e-10 \
        -num_threads "${THREADS}"

    awk -v id="${IDENTITY}" -v len="${MINLEN[$TYPE]}" \
        '$3 >= id && $4 >= len' \
        "Ksch.${TYPE}.rRNA.blast.out" \
        > "Ksch.${TYPE}.rRNA.filtered.out"

    awk -v type="${TYPE}_rRNA" 'BEGIN{OFS="\t"}{
        start=($9<$10?$9:$10)-1;
        end=($9>$10?$9:$10);
        strand=($9<=$10?"+":"-");
        print $2,start,end,type,".",strand
    }' \
        "Ksch.${TYPE}.rRNA.filtered.out" \
        > "Ksch.${TYPE}.rRNA.bed"

    bedtools sort \
        -i "Ksch.${TYPE}.rRNA.bed" | \
    bedtools merge \
        -s \
        -d 100 \
        -c 4,6 \
        -o distinct,distinct \
        > "Ksch.${TYPE}.rRNA.merged.bed"

    awk -v type="${TYPE}_rRNA" 'BEGIN{OFS="\t"}{
        print $1,"BLAST","rRNA",$2+1,$3,".",$5,".",
        "ID="type"_"NR";Name="type
    }' \
        "Ksch.${TYPE}.rRNA.merged.bed" \
        > "Ksch.${TYPE}.rRNA.gff3"

done

{
    echo "##gff-version 3"
    cat Ksch.5S.rRNA.gff3
    cat Ksch.5.8S.rRNA.gff3
    cat Ksch.18S.rRNA.gff3
    cat Ksch.28S.rRNA.gff3
} > Ksch.rRNA.gff3
