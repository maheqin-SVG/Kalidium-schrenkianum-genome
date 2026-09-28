### Command

cat \
  Ksch.homolog_prediction.gff3 \
  Ksch.tmp/5.augustus/augustus.gff3 \
  > Ksch.EVM.gene_predictions.gff3

cat > Ksch.EVM.weights.txt <<'EOF'
TRANSCRIPT	ChenLianfu	10
OTHER_PREDICTION	GETA	5
ABINITIO_PREDICTION	AUGUSTUS	1
EOF

perl EVidenceModeler-1.1.1/EvmUtils/partition_EVM_inputs.pl \
  --genome Ksch.final.clean.fa \
  --gene_predictions Ksch.EVM.gene_predictions.gff3 \
  --transcript_alignments Ksch.transfrag_alignment.gff3 \
  --repeats Ksch.repeat.gff3 \
  --segmentSize 5000000 \
  --overlapSize 10000 \
  --partition_listing Ksch.EVM.partitions.list

perl EVidenceModeler-1.1.1/EvmUtils/write_EVM_commands.pl \
  --genome Ksch.final.clean.fa \
  --weights Ksch.EVM.weights.txt \
  --gene_predictions Ksch.EVM.gene_predictions.gff3 \
  --transcript_alignments Ksch.transfrag_alignment.gff3 \
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
- `Ksch.transfrag_alignment.gff3`
- `Ksch.homolog_prediction.gff3`
- `Ksch.tmp/5.augustus/augustus.gff3`
- `Ksch.repeat.gff3`

### Output

- `Ksch.EVM.gene_predictions.gff3`
- `Ksch.EVM.weights.txt`
- `Ksch.EVM.partitions.list`
- `Ksch.EVM.commands.list`
- EVM partition outputs in GFF3 format

### Input–output relationship

Transcriptome evidence
+ homology-based gene predictions
+ AUGUSTUS ab initio predictions
+ RepeatMasker annotations
→ weighted integration with EVidenceModeler
→ partitioned EVM predictions
→ recombination of all partitions
→ final consensus gene annotation in GFF3 format

Transcriptome-based, homology-based, and ab initio evidence were assigned relative weights of 10, 5, and 1, respectively. 
EVM was run in 5-Mb segments with 10-kb overlaps, and RepeatMasker annotations were included during evidence integration.
