#!/bin/bash
set -euo pipefail

PROTEIN="ksch.pep"
FILTERED_PROTEIN="ksch.pep.flt"

FASTA_SPLITTER="/path/to/fasta-splitter.pl"
INTERPROSCAN="/path/to/interproscan-5.52-86.0/interproscan.sh"
MAKEBLASTDB="/path/to/ncbi-blast-2.13.0+/bin/makeblastdb"
BLASTP="/path/to/ncbi-blast-2.13.0+/bin/blastp"
DIAMOND="/path/to/diamond"

SWISSPROT_FASTA="uniprot_sprot.fasta"
SWISSPROT_FUNCTION="swiss_port.fasta.function"
NR_DB="/path/to/nr.dmnd"
KOG_FASTA="kyva"
KEGG_KO="query.ko"

# Filter protein sequences
perl - "${PROTEIN}" <<'PERL' > "${FILTERED_PROTEIN}"
use strict;
use warnings;
use Bio::SeqIO;

my $in=shift;
my $fa=Bio::SeqIO->new(-file=>$in,-format=>"fasta");

while (my $seq=$fa->next_seq) {
    my $id=$seq->id;
    my $desc=$seq->desc;
    my $s=$seq->seq;
    $s=~s/\*$//;
    $s=~s/\*//g;
    print ">$id $desc\n$s\n";
}
PERL

# InterProScan annotation
mkdir -p 01.split 02.interproscan.out

perl "${FASTA_SPLITTER}" \
    --n-parts 50 \
    --out-dir 01.split \
    "${FILTERED_PROTEIN}"

for file in ./01.split/*.flt; do
    name=$(basename "${file}" .flt)

    "${INTERPROSCAN}" \
        -f tsv \
        -i "${file}" \
        -o "./02.interproscan.out/${name}.tsv" \
        -iprlookup \
        -goterms \
        -pa \
        -t p
done

cat 02.interproscan.out/*.tsv > 02.interpro.out.tsv

# Parse InterPro annotations
perl - 02.interpro.out.tsv <<'PERL' > 03.phase.interproscan.out
use strict;
use warnings;

my %h;
my $in=shift;

open(F,$in) or die "$!\n";

while(<F>){
    chomp;
    my @a=split(/\t/,$_);

    if (/(IPR\S+)\t([^\t]+)/){
        my $k="$1 $2";
        $h{$a[0]}{$k}++;
    }
}

close F;

for my $k (sort keys %h){
    my @k2=sort keys %{$h{$k}};
    print "$k\t",scalar(@k2),"\t",join("\t",@k2),"\n";
}
PERL

# Extract InterPro accession numbers
perl - 03.phase.interproscan.out <<'PERL' > InterPro.IPR.tsv
use strict;
use warnings;

my $file=shift;
my %h;

open(I,$file) or die "$!\n";

while(<I>){
    chomp;
    my @l=split(/\s+/,$_);

    foreach my $i (@l){
        if ($i=~/IPR\d+/){
            $h{$l[0]}{$i}++;
        }
    }
}

close I;

foreach my $i (sort keys %h){
    print "$i\t";
    foreach my $j (sort keys %{$h{$i}}){
        print "$j\t";
    }
    print "\n";
}
PERL

cut -f 1 InterPro.IPR.tsv | \
    sort -u \
    > InterPro.annotated_genes.txt

# GO annotation
perl - 02.interpro.out.tsv <<'PERL' > GO.annotation.tsv
use strict;
use warnings;

my %h;
my $in=shift;

open(F,$in) or die "$!\n";

while(<F>){
    chomp;
    my @a=split(/\t/,$_);

    if (/\s+(GO:\S+)/){
        my $go=$1;
        my @go=split(/\|/,$go);

        for my $GO (@go){
            $h{$a[0]}{$GO}++;
        }
    }
}

close F;

for my $k (sort keys %h){
    my @k2=sort keys %{$h{$k}};
    print "$k\t",join("\t",@k2),"\n";
}
PERL

cut -f 1 GO.annotation.tsv | \
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

perl - "${SWISSPROT_FUNCTION}" swiss-prot.out <<'PERL' \
    > swiss-prot.out.function \
    2> SwissProt.annotation.log
use strict;
use warnings;

my $func=shift;
my $blast=shift;

my %f;

open(F,$func) or die "$!\n";

while(<F>){
    chomp;

    if (/(>sp\|\w+\|\S+)\s+(.*)/){
        my $id=$1;
        $id=~s/^>//;
        $f{$id}=$2;
    }
}

close F;

my %g;

open(B,$blast) or die "$!\n";

while(<B>){
    chomp;
    next if /^#/;

    my @l=split(/\s+/,$_);

    next if exists $g{$l[0]};
    $g{$l[0]}=$l[1];
}

close B;

my $n=keys %g;
print STDERR "$blast have annotated: $n\n";

foreach my $gene (sort keys %g){
    my $hit=$g{$gene};
    my $function=exists $f{$hit} ? $f{$hit} : "";
    print "$gene\t$hit\t$function\n";
}
PERL

cut -f 1 swiss-prot.out.function | \
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
# KO assignments were obtained using the KEGG KAAS web server.

grep 'K' "${KEGG_KO}" > kegg.out

cut -f 1 kegg.out | \
    sort -u \
    > KEGG.annotated_genes.txt
