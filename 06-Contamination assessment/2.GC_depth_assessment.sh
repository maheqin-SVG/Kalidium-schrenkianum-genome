### Command

minimap2 -ax map-hifi -t 16 \
  Ksch.no_organelle.fa \
  Ksch.HiFi.fasta | \
samtools view -bh -F 2308 -q 20 - | \
samtools sort -@ 8 \
  -o Ksch.HiFi.q20.bam

samtools index Ksch.HiFi.q20.bam
samtools faidx Ksch.no_organelle.fa

cut -f1,2 Ksch.no_organelle.fa.fai \
  > Ksch.genome.sizes

bedtools makewindows \
  -g Ksch.genome.sizes \
  -w 10000 \
  > Ksch.10kb.bed

bedtools coverage \
  -a Ksch.10kb.bed \
  -b Ksch.HiFi.q20.bam \
  -mean \
  > Ksch.10kb.depth.bed

bedtools nuc \
  -fi Ksch.no_organelle.fa \
  -bed Ksch.10kb.bed \
  > Ksch.10kb.nuc.tsv

awk 'BEGIN{OFS="\t"} NR>1 {print $1,$2,$3,$5*100}' \
  Ksch.10kb.nuc.tsv \
  > Ksch.10kb.GC.bed

paste Ksch.10kb.depth.bed Ksch.10kb.GC.bed | \
awk 'BEGIN{OFS="\t"} {print $1,$2,$3,$4,$8}' \
  > Ksch.10kb.GC_depth.tsv

### Software

- minimap2 v2.30-r1287
- SAMtools v1.6
- BEDTools v2.26.0

### Input

- `Ksch.no_organelle.fa`
- `Ksch.HiFi.fasta`

### Output

- `Ksch.HiFi.q20.bam`
- `Ksch.10kb.bed`
- `Ksch.10kb.depth.bed`
- `Ksch.10kb.GC.bed`
- `Ksch.10kb.GC_depth.tsv`

### Input–output relationship

`Ksch.no_organelle.fa`
+ PacBio HiFi reads
→ HiFi read mapping and MAPQ ≥20 filtering
→ non-overlapping 10-kb genomic windows
→ calculation of mean sequencing depth and GC content
→ `Ksch.10kb.GC_depth.tsv`
