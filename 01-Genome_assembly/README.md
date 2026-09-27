## Juicebox manual curation

The initial Juicebox assembly (`out_JBAT.assembly`) and the manually reviewed assembly (`out_JBAT.review.new.assembly`) are provided to document the Hi-C manual curation process.

### Manual correction records

`Juicebox_manual_corrections.tsv` records 14 traceable manual corrections, including:

- 8 split breakpoints
- 4 fragments moved to debris
- 2 reorientation events

`Juicebox_split_coordinates.tsv` provides the reconstructed coordinates of all split fragments on their original contigs.

### Contamination removal

Following Juicebox curation, 73 contaminant scaffolds were removed:

- 60 organelle-derived scaffolds identified by chloroplast and mitochondrial alignments
- 13 scaffolds flagged by FCS-GX as foreign contamination from *Contarinia nasturtii* and recommended for complete removal (“EXCLUDE”)

The final contamination-cleaned reviewed assembly and AGP are provided as:

- `out_JBAT.review.new.clean.assembly`
- `Ksch_new_clean.FINAL.agp`





















