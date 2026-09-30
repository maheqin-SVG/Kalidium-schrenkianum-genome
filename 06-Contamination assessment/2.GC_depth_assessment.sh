### Command

samtools fastq -@ 8 -F 2304 ksch.hifi_reads.bam | \
gzip -c > Ksch.HiFi.fastq.gz

samtools faidx Ksch.final.clean.fa

cut -f1,2 Ksch.final.clean.fa.fai \
  > Ksch.final.clean.chrom.sizes

minimap2 -ax map-hifi -t 32 \
  Ksch.final.clean.fa Ksch.HiFi.fastq.gz | \
samtools view -@ 8 -bh -F 2308 -q 20 - | \
samtools sort -@ 8 -o Ksch.final.clean.HiFi.q20.bam -

samtools index Ksch.final.clean.HiFi.q20.bam

samtools flagstat Ksch.final.clean.HiFi.q20.bam \
  > Ksch.final.clean.HiFi.flagstat.txt

samtools coverage Ksch.final.clean.HiFi.q20.bam \
  > Ksch.final.clean.HiFi.scaffold_coverage.tsv

bedtools makewindows \
  -g Ksch.final.clean.chrom.sizes \
  -w 10000 \
  > Ksch.final.clean.10kb.bed

bedtools coverage \
  -a Ksch.final.clean.10kb.bed \
  -b Ksch.final.clean.HiFi.q20.bam \
  -mean \
  > Ksch.final.clean.10kb.depth.q20.bed

bedtools nuc \
  -fi Ksch.final.clean.fa \
  -bed Ksch.final.clean.10kb.bed \
  > Ksch.final.clean.10kb.nuc.tsv

awk 'BEGIN{OFS="\t"} NR>1 {print $1,$2,$3,$5*100}' \
  Ksch.final.clean.10kb.nuc.tsv \
  > Ksch.final.clean.10kb.GC.bed

echo -e "Chr\tStart\tEnd\tMean_depth\tGC_percent" \
  > Ksch.final.clean.10kb.GC_depth.q20.tsv

paste Ksch.final.clean.10kb.depth.q20.bed \
      Ksch.final.clean.10kb.GC.bed | \
awk 'BEGIN{OFS="\t"} {print $1,$2,$3,$4,$8}' \
  >> Ksch.final.clean.10kb.GC_depth.q20.tsv


### Software

- minimap2 v2.30-r128
- SAMtools v1.6
- BEDTools v2.26.0


### Input

- Ksch.final.clean.fa
- ksch.hifi_reads.bam


### Output

- Ksch.HiFi.fastq.gz
- Ksch.final.clean.HiFi.q20.bam
- Ksch.final.clean.HiFi.flagstat.txt
- Ksch.final.clean.HiFi.scaffold_coverage.tsv
- Ksch.final.clean.10kb.bed
- Ksch.final.clean.10kb.depth.q20.bed
- Ksch.final.clean.10kb.nuc.tsv
- Ksch.final.clean.10kb.GC.bed
- Ksch.final.clean.10kb.GC_depth.q20.tsv


### Input–output relationship

Final contamination-filtered assembly (Ksch.final.clean.fa)
+ PacBio HiFi reads (ksch.hifi_reads.bam)
→ BAM-to-FASTQ conversion
→ minimap2 mapping (-x map-hifi)
→ Primary alignment filtering (MAPQ ≥20)
→ Non-overlapping 10-kb genomic windows
→ Mean sequencing depth and GC content calculation
→ Ksch.final.clean.10kb.GC_depth.q20.tsv
→ Genome-wide GC–depth contamination assessment
