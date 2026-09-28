### Command

cat \
  Ksch.homolog_prediction.gff3 \
  augustus.gff3 \
  > Ksch.EVM.gene_predictions.gff3

gtf_to_alignment_gff3.pl \
  Ksch.stringtie.merged.gtf \
  > Ksch.stringtie.merged.alignment.gff3

cat > Ksch.EVM.weights.txt <<'EOF'
TRANSCRIPT	StringTie	10
OTHER_PREDICTION	GETA	5
ABINITIO_PREDICTION	AUGUSTUS	1
EOF

perl EVidenceModeler-1.1.1/EvmUtils/partition_EVM_inputs.pl \
  --genome Ksch.final.clean.fa \
  --gene_predictions Ksch.EVM.gene_predictions.gff3 \
  --transcript_alignments Ksch.stringtie.merged.alignment.gff3 \
  --repeats Ksch.repeat.gff3 \
  --segmentSize 5000000 \
  --overlapSize 10000 \
  --partition_listing Ksch.EVM.partitions.list

perl EVidenceModeler-1.1.1/EvmUtils/write_EVM_commands.pl \
  --genome Ksch.final.clean.fa \
  --weights Ksch.EVM.weights.txt \
  --gene_predictions Ksch.EVM.gene_predictions.gff3 \
  --transcript_alignments Ksch.stringtie.merged.alignment.gff3 \
  --repeats Ksch.repeat.gff3 \
  --output_file_name Ksch.EVM.out \
  --partitions Ksch.EVM.partitions.list \
  > Ksch.EVM.commands.list

perl EVidenceModeler-1.1.1/EvmUtils/execute_EVM_commands.pl \
  Ksch.EVM.commands.list

perl EVidenceModeler-1.1.1/EvmUtils/recombine_EVM_partial_outputs.pl \
  --partitions Ksch.EVM.partitions.list \
  --output_file_name Ksch.EVM.out

perl EVidenceModeler-1.1.1/EvmUtils/convert_EVM_outputs_to_GFF3.pl \
  --partitions Ksch.EVM.partitions.list \
  --output Ksch.EVM.out \
  --genome Ksch.final.clean.fa

### Software

- EVidenceModeler v1.1.1

### Input

- `Ksch.final.clean.fa`
- `Ksch.stringtie.merged.gtf`
- `Ksch.homolog_prediction.gff3`
- `augustus.gff3`
- `Ksch.repeat.gff3`

### Output

- `Ksch.stringtie.merged.alignment.gff3`
- `Ksch.EVM.gene_predictions.gff3`
- `Ksch.EVM.weights.txt`
- `Ksch.EVM.partitions.list`
- `Ksch.EVM.commands.list`
- `Ksch.EVM.final.gff3`

### Input–output relationship

`Ksch.stringtie.merged.gtf`
→ conversion to transcript-alignment GFF3
→ `Ksch.stringtie.merged.alignment.gff3`

`Ksch.homolog_prediction.gff3`
+ `augustus.gff3`
→ combined gene-prediction file
→ `Ksch.EVM.gene_predictions.gff3`

`Ksch.stringtie.merged.alignment.gff3`
+ `Ksch.EVM.gene_predictions.gff3`
+ `Ksch.repeat.gff3`
+ `Ksch.final.clean.fa`

### Input–output relationship

`Ksch.stringtie.merged.gtf`
→ conversion to transcript-alignment GFF3
→ `Ksch.stringtie.merged.alignment.gff3`

`Ksch.homolog_prediction.gff3`
+ `augustus.gff3`
→ combined gene-prediction file
→ `Ksch.EVM.gene_predictions.gff3`

`Ksch.stringtie.merged.alignment.gff3`
+ `Ksch.EVM.gene_predictions.gff3`
+ `Ksch.repeat.gff3`
+ `Ksch.final.clean.fa`
→ weighted evidence integration with EVidenceModeler
→ `Ksch.EVM.final.gff3`

Transcriptome-based, homology-based, and ab initio evidence were assigned relative weights of 10, 5, and 1, respectively. 
EVM was run in 5-Mb segments with 10-kb overlaps, and RepeatMasker annotations were included during evidence integration.
