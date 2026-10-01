### Command
for sp in Bvul Hara Ksch; do
  python -m jcvi.formats.gff bed \
    --type=mRNA \
    --key=ID \
    ${sp}.gff3 > ${sp}.bed

  python -m jcvi.formats.bed uniq ${sp}.bed
  mv ${sp}.uniq.bed ${sp}.bed

  gffread ${sp}.gff3 \
    -g ${sp}_genome.fasta \
    -x ${sp}.all.cds.fa

  seqkit grep \
    -f <(cut -f 4 ${sp}.bed) \
    ${sp}.all.cds.fa | \
  seqkit seq -i > ${sp}.cds
done

python -m jcvi.compara.catalog ortholog \
  --no_strip_names Ksch Bvul

python -m jcvi.compara.catalog ortholog \
  --no_strip_names Hara Ksch

python -m jcvi.compara.catalog ortholog \
  --no_strip_names Hara Bvul

python -m jcvi.compara.synteny screen \
  --minspan=30 --simple \
  Ksch.Bvul.anchors Ksch.Bvul.anchors.new

python -m jcvi.compara.synteny screen \
  --minspan=30 --simple \
  Hara.Ksch.anchors Hara.Ksch.anchors.new

python -m jcvi.compara.synteny screen \
  --minspan=30 --simple \
  Hara.Bvul.anchors Hara.Bvul.anchors.new

python -m jcvi.graphics.karyotype \
  all.seqids \
  layout

Software
- JCVI v1.5.7
- GffRead v0.12.7
- SeqKit v2.12.0

Input
- Ksch.gff3
- Ksch_genome.fasta
- Hara.gff3
- Hara_genome.fasta
- Bvul.gff3
- Bvul_genome.fasta
- all.seqids
- layout

Output
- Ksch.bed
- Hara.bed
- Bvul.bed
- Ksch.cds
- Hara.cds
- Bvul.cds
- Ksch.Bvul.anchors.simple
- Hara.Ksch.anchors.simple
- Hara.Bvul.anchors.simple
- chromosome-level synteny figure

Input–output relationship
Genome GFF3 and FASTA files from K. schrenkianum, H. arachnoideus, and B. vulgaris
→ preparation of BED and CDS files
→ pairwise ortholog and syntenic-anchor identification
→ filtering of syntenic blocks with --minspan=30 --simple
→ chromosome-level synteny visualization with JCVI
