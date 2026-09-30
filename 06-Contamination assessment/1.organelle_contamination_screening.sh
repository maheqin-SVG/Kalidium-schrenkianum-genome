### Command

samtools fasta -@ 32 Ksch.hifi.bam > Ksch.HiFi.fa

himt assemble -i Ksch.HiFi.fa -o Ksch_organelle -t 32

minimap2 -x asm5 -t 32 \
  ksch_genome.fasta Ksch.chloroplast.fa \
  > chloroplast_vs_nuclear.paf

minimap2 -x asm5 -t 32 \
  ksch_genome.fasta Ksch.mitochondrial.fa \
  > mitochondrial_vs_nuclear.paf

for TYPE in chloroplast mitochondrial; do
  awk 'BEGIN{OFS="\t"} {print $6,$8,$9}' \
    ${TYPE}_vs_nuclear.paf | \
  sort -k1,1 -k2,2n | \
  bedtools merge -i - > ${TYPE}.merged.bed
done

samtools faidx ksch_genome.fasta

python3 calculate_organelle_coverage.py

seqkit grep -v \
  -f remove_scaffolds.ids \
  ksch_genome.fasta \
  > Ksch.final.clean.fa

seqkit seq -n Ksch.final.clean.fa > Ksch.final.clean.ids

python3 fasta_stats.py Ksch.final.clean.fa \
  > assembly.after_removal.tsv

python3 compare_before_after.py

### Software

- HiMT v1.1.4
- minimap2 v2.30-r128
- SAMtools v1.6
- BEDTools v2.26.0
- SeqKit v2.12.0
- Python 3

### Input

- `Ksch.hifi.bam` — PacBio HiFi reads
- `ksch_genome.fasta` — Assembly before filtering
- `Ksch.chloroplast.fa` — Chloroplast reference
- `Ksch.mitochondrial.fa` — Mitochondrial reference

### Output

- `chloroplast_vs_nuclear.paf`
- `mitochondrial_vs_nuclear.paf`
- `chloroplast.merged.bed`
- `mitochondrial.merged.bed`
- `all_organelle.merged.bed`
- `all_scaffold_organelle_coverage.tsv`
- `candidate_organelle_scaffolds.tsv`
- `remove_scaffolds.ids`
- `Ksch.final.clean.fa`
- `assembly_before_after.tsv`

### Input–output relationship

HiFi reads → HiMT organelle assembly → minimap2 alignment → merged nuclear alignment intervals → non-redundant organellar coverage (CP + MT) → removal of scaffolds with ≥50% coverage → final cleaned assembly.

### Summary

A total of 60 candidate organelle-derived scaffolds (3,312,179 bp) were removed, reducing the assembly from 521 scaffolds (988,689,271 bp) to 461 scaffolds (985,377,092 bp). Scaffold N50 remained unchanged at 104,900,589 bp.
