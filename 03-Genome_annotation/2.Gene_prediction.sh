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

Detailed EVidenceModeler commands and evidence weights are provided in
`EVM_commands.sh`, respectively.

### Software

- GETA
- RepeatMasker v4.1.0
- HISAT2 v2.1.0
- StringTie v2.2.1
- TransDecoder
- GeneWise v2.4.1
- AUGUSTUS v3.3.3
- EVidenceModeler v1.1.1

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

- `Ksch.repeat.gff3`
- `Ksch.homolog_prediction.gff3`
- `Ksch.stringtie.merged.gtf`
- `Ksch.stringtie.merged.alignment.gff3`
- `augustus.gff3`
- `Ksch.EVM.gene_predictions.gff3`
- `Ksch.EVM.weights.txt`
- `Ksch.EVM.partitions.list`
- `Ksch.EVM.commands.list`
- `Ksch.EVM.final.gff3`

### Input–output relationship

`Ksch.final.clean.fa`
+ RNA-seq reads
+ homologous proteins
→ GETA-based gene prediction
→ repeat annotation, transcript-supported models,
homology-based gene models, and AUGUSTUS ab initio predictions

RNA-seq alignments
→ StringTie transcript assembly
→ `Ksch.stringtie.merged.gtf`
→ `Ksch.stringtie.merged.alignment.gff3`

`Ksch.homolog_prediction.gff3`
+ `augustus.gff3`
→ `Ksch.EVM.gene_predictions.gff3`

`Ksch.stringtie.merged.alignment.gff3`
+ `Ksch.EVM.gene_predictions.gff3`
+ `Ksch.repeat.gff3`
+ `Ksch.final.clean.fa`
→ weighted integration with EVidenceModeler
→ `Ksch.EVM.final.gff3`

Transcriptome-based, homology-based, and ab initio evidence were assigned relative weights of 10, 5, and 1, respectively. 
EVM was run in 5-Mb segments with 10-kb overlaps, and RepeatMasker annotations were included during evidence integration.
