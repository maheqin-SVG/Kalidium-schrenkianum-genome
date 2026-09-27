### Command

geta.pl \
  --RM_species Viridiplantae \
  --genome Ksch.final.clean.fa \
  -1 ksch-RNA_stem.r1.fq.gz,ksch-RNA_leaf.r1.fq.gz \
  -2 ksch-RNA_stem.r2.fq.gz,ksch-RNA_leaf.r2.fq.gz \
  --protein homolog.fasta \
  --augustus_species Ksch \
  --cpu 32 \
  --out_prefix Ksch \
  --gene_prefix Ksch \
  --config conf_for_big_genome.txt \
  --pfam_db Pfam-AB.hmm

### Software

- GETA
- RepeatMasker v4.1.0
- HISAT2 v2.1.0
- GeneWise v2.4.1
- AUGUSTUS v3.3.3
StringTie v2.2.1
EvidenceModeler v1.1.1

### Input

- `Ksch.final.clean.fa`
- `ksch-RNA_stem.r1.fq.gz`
- `ksch-RNA_stem.r2.fq.gz`
- `ksch-RNA_leaf.r1.fq.gz`
- `ksch-RNA_leaf.r2.fq.gz`
- `homolog.fasta`
- `Pfam-AB.hmm`
- `conf_for_big_genome.txt`

### Output

- Repeat-masked genome
- RNA-seq-supported transcript models
- Homology-based gene models
- AUGUSTUS ab initio gene models
- Integrated protein-coding gene models
- Final GFF3 annotation
