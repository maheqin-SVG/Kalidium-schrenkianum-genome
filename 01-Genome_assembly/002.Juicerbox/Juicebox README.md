# Juicebox manual curation

The initial Juicebox assembly (`out_JBAT.assembly`) and the manually curated assembly (`out_JBAT.review.new.assembly`) are provided to document the Hi-C manual curation process.

### Manual correction records

`Juicebox_manual_corrections.tsv` records 14 traceable manual corrections, including:

- 8 split breakpoints
- 4 fragments moved to debris
- 2 reorientation events

`Juicebox_split_coordinates.tsv` provides the reconstructed coordinates of all split fragments on their original contigs.

### Post-curation assembly

The manually curated Juicebox assembly (`out_JBAT.review.new.assembly`) was processed using the HapHiC `juicer post` utility to reconstruct the Hi-C-curated chromosome-scale genome assembly.
















