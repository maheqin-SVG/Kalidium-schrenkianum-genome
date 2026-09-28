### Command

# Assemble chloroplast and mitochondrial genomes from HiFi reads
samtools fasta -@ 32 Ksch.hifi.bam > Ksch.HiFi.fa

himt assemble \
  -i Ksch.HiFi.fa \
  -o Ksch_organelle \
  -t 32

# Align organelle genomes to the nuclear assembly
minimap2 -x asm5 -t 32 \
  Ksch_genome.fasta chloroplast.fa \
  > Ksch.cp.paf

minimap2 -x asm5 -t 32 \
  Ksch_genome.fasta mitochondrial.fa \
  > Ksch.mt.paf

# Merge organelle-aligned regions
for TYPE in cp mt; do
  awk 'BEGIN{OFS="\t"} {print $1,$3,$4}' Ksch.${TYPE}.paf | \
  sort -k1,1 -k2,2n | \
  bedtools merge -i - \
  > Ksch.${TYPE}.merged.bed
done

# Identify scaffolds with >=50% organelle-derived coverage
samtools faidx Ksch_genome.fasta

for TYPE in cp mt; do
  awk '
  NR==FNR {len[$1]=$2; next}
  {cov[$1]+=$3-$2}
  END {
      for (id in len)
          if (cov[id]/len[id] >= 0.5)
              print id
  }' \
  Ksch_genome.fasta.fai \
  Ksch.${TYPE}.merged.bed \
  > Ksch.${TYPE}.candidate.ids
done

# Remove candidate organelle-derived scaffolds
cat Ksch.cp.candidate.ids Ksch.mt.candidate.ids | \
sort -u > Ksch.organelle_candidate.ids

seqkit grep -v \
  -f Ksch.organelle_candidate.ids \
  Ksch_genome.fasta \
  > Ksch.no_organelle.fa

### Software

- HiMT v1.1.4
- minimap2 v2.30-r1287
- BEDTools v2.26.0
- SAMtools v1.6
- SeqKit v2.12.0

### Input

- `Ksch.hifi.bam`
- `Ksch_genome.fasta`
- HiMT-generated chloroplast assembly
- HiMT-generated mitochondrial assembly

### Output

- `Ksch.cp.paf`
- `Ksch.mt.paf`
- `Ksch.cp.merged.bed`
- `Ksch.mt.merged.bed`
- `Ksch.cp.candidate.ids`
- `Ksch.mt.candidate.ids`
- `Ksch.organelle_candidate.ids`
- `Ksch.no_organelle.fa`

### Input–output relationship

HiFi reads
→ HiMT organelle assembly
→ chloroplast and mitochondrial reference sequences

Nuclear genome assembly
+ organelle references
→ minimap2 alignment
→ merged organelle-covered regions
→ scaffolds with ≥50% organelle coverage
→ removal of candidate organelle-derived scaffolds
→ `Ksch.no_organelle.fa`

Scaffolds with at least 50% of their length covered by non-redundant chloroplast or mitochondrial alignments were classified as candidate organelle-derived sequences and removed from the nuclear assembly.
