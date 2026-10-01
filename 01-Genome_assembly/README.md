# Genome assembly

This directory contains the scripts and supporting files used for the chromosome-scale genome assembly of *Kalidium schrenkianum*, including HiFi assembly, Hi-C scaffolding, and Juicebox manual curation.

### `001.Workflow`

Scripts for genome assembly and Hi-C scaffolding:

- `1.HiFi_assembly.sh` — HiFi-based primary genome assembly
- `2.HiC_scaffolding.sh` — Hi-C read mapping, HapHiC scaffolding, Juicebox file preparation, and reconstruction of the manually curated assembly

### `002.Juicerbox`

Records of manual Hi-C curation:

- `Juicebox_manual_corrections.tsv` — records of 14 manual corrections, including 8 split breakpoints, 4 fragments moved to debris, and 2 reorientation events
- `Juicebox_split_coordinates.tsv` — coordinates of split fragments on their original contigs

### `003.assembly.files`

Juicebox assembly files documenting the manual curation process:

- `out_JBAT.assembly` — initial Juicebox assembly
- `out_JBAT.review.new.assembly` — manually curated Juicebox assembly
