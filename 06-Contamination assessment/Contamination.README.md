
# 06. Contamination Assessment

This directory contains scripts and supporting results for organellar contamination removal, GC–depth assessment, and Kraken2 taxonomic screening of the *Kalidium schrenkianum* genome assembly.

## Analysis workflows

1. **`1.organelle_contamination_screening.sh`** — Identifies and removes candidate organelle-derived scaffolds based on chloroplast and mitochondrial sequence alignments and ≥50% non-redundant organellar coverage.
2. **`2.GC_depth_assessment.sh`** — Calculates GC content and mean HiFi sequencing depth in non-overlapping 10-kb genomic windows.
3. **`3.Kraken2_screening`** — Performs taxonomic classification using Kraken2 v2.1.2 and the PlusPFP-16 database (release 20260626).

## Supporting results

- `Ksch.organelle_candidate.ids.tsv` — Candidate organelle-derived scaffold identifiers.
- `Ksch.final.clean.10kb.GC_depth.q20.tsv` — Genome-wide GC–depth statistics for 10-kb windows.
- `Ksch.final.clean.kraken2.report` — Kraken2 taxonomic classification report.

## Summary

Following organellar contamination filtering, 60 candidate scaffolds (3.31 Mb) were removed, yielding a final assembly of 461 scaffolds (985.38 Mb). GC–depth assessment and Kraken2 screening were subsequently performed on the filtered assembly. No additional scaffolds were removed based on Kraken2 screening.

Detailed commands, software parameters, and input–output relationships are provided in the corresponding workflow files.
