#!/bin/bash
set -euo pipefail

GFF="ksch.fa.mod.EDTA.intact.gff3"
OUT="Ksch.LTR_identity.tsv"

awk -F'\t' '
BEGIN{
    OFS="\t"
    print "Chr","Type","Identity"
}
$3=="repeat_region" && $9~/Classification=LTR\/(Copia|Gypsy)/ && $9~/ltr_identity=/ {
    type=""
    identity=""

    n=split($9,a,";")

    for(i=1;i<=n;i++){
        gsub(/^[[:space:]]+|[[:space:]]+$/,"",a[i])

        if(a[i]~/^Classification=LTR\//){
            type=a[i]
            sub(/^Classification=LTR\//,"",type)
        }

        if(a[i]~/^ltr_identity=/){
            identity=a[i]
            sub(/^ltr_identity=/,"",identity)
        }
    }

    if((type=="Copia" || type=="Gypsy") && identity!="")
        print $1,type,identity
}
' "${GFF}" > "${OUT}"
