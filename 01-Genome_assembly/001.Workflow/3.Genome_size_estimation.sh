# Commands

jellyfish count -C -m 27 -s 30G -t 32 \
    -o ksch.clean.reads27.jf \
    <(zcat Ksch.survey.clean.R1.fq.gz Ksch.survey.clean.R2.fq.gz)

jellyfish histo -t 32 \
    ksch.clean.reads27.jf \
    > ksch.reads27.histo

# Software
- Jellyfish v2.2.10

# Input
- `Ksch.survey.clean.R1.fq.gz`
- `Ksch.survey.clean.R2.fq.gz`

# Output
- `ksch.clean.reads27.jf`: Jellyfish 27-mer count database.
- `ksch.reads27.histo`: 27-mer frequency histogram used for genome size estimation.

# Input-output relationship

`Ksch.survey.clean.R1.fq.gz` + `Ksch.survey.clean.R2.fq.gz`
→ Jellyfish 27-mer counting
→ `ksch.clean.reads27.jf`
→ Jellyfish histogram
→ `ksch.reads27.histo`
→ GenomeScope v2.0
