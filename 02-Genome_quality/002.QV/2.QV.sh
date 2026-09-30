### Command

meryl k=21 count \
  threads=16 \
  output Ksch.R1.meryl \
  Ksch.survey.R1.fq.gz

meryl k=21 count \
  threads=16 \
  output Ksch.R2.meryl \
  Ksch.survey.R2.fq.gz

meryl union-sum \
  output Ksch.reads.meryl \
  Ksch.R1.meryl \
  Ksch.R2.meryl

merqury.sh \
  Ksch.reads.meryl \
  Ksch.final.clean.fa \
  Ksch

cat Ksch.qv
cat Ksch.completeness.stats

### Software

- Merqury v1.4.1
- k-mer size: 21

### Input

- `Ksch.survey.R1.fq.gz`
- `Ksch.survey.R2.fq.gz`
- `Ksch.final.clean.fa`

### Output

- `Ksch.R1.meryl/`
- `Ksch.R2.meryl/`
- `Ksch.reads.meryl/`
- `Ksch.qv`
- `Ksch.completeness.stats`

### Input–output relationship

`Ksch.survey.R1.fq.gz` + `Ksch.survey.R2.fq.gz`
→ 21-mer counting with Meryl
→ `Ksch.R1.meryl` + `Ksch.R2.meryl`
→ merged read k-mer database `Ksch.reads.meryl`

`Ksch.reads.meryl` + `Ksch.final.clean.fa`
→ Merqury assessment
→ `Ksch.qv` + `Ksch.completeness.stats`

The paired-end Illumina genome-survey reads were used to construct a 21-mer database with Meryl. 
The two read-specific k-mer databases were combined using `union-sum`, and the merged database was compared with the final genome assembly (`Ksch.final.clean.fa`) using Merqury to estimate consensus QV and k-mer completeness.
