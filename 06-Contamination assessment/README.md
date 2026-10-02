# Contamination assessment

This directory contains the workflows, supporting scripts, and results used for contamination assessment of the *Kalidium schrenkianum* genome assembly.

### `Work flow`

Scripts for contamination screening and GC–depth assessment:

- `1.organelle_contamination_screening.sh` — identification and removal of organelle-derived scaffolds based on chloroplast and mitochondrial sequence alignments
- `2.GC_depth_assessment.sh` — calculation of GC content and HiFi sequencing depth in non-overlapping 10-kb windows
- `3.GC_depth_plot.R` — visualization of the joint distribution of GC content and HiFi sequencing depth
- `4.Kraken2_screening.sh` — taxonomic screening of the contamination-cleaned genome using Kraken2

### `Supporting scripts`

Supporting scripts for contamination assessment:

- `calculate_organelle_coverage.py` — calculation of chloroplast and mitochondrial sequence coverage for candidate scaffolds
- `fasta_stats.py` — calculation of genome assembly statistics
- `compare_before_after.py` — comparison of assembly statistics before and after contamination removal

### `Supporting results`

Key supporting results:

- `FCS-GX.contamination.tsv` — FCS-GX contamination screening results
- `candidate_organelle_scaffolds.tsv` — candidate organelle-derived scaffolds and coverage statistics
- `Ksch.final.clean.10kb.GC_depth.q20.tsv` — GC content and mean HiFi sequencing depth for 10-kb genomic windows
- `Ksch.final.clean.kraken2.report` — Kraken2 taxonomic classification results

## Summary

A total of 60 organelle-derived scaffolds (3,312,179 bp) were removed, reducing the assembly from 521 scaffolds (988,689,271 bp) to 461 scaffolds (985,377,092 bp). 
No additional scaffolds were removed following Kraken2 screening.
