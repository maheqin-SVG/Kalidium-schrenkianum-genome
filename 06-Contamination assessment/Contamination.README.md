# 06. Contamination Assessment

This directory contains the scripts and supporting results for organellar contamination filtering, GC–depth assessment, and Kraken2 screening of the *Kalidium schrenkianum* genome assembly.

## Analysis workflows

- `1.organelle_contamination_screening.sh` — Organelle genome alignment and removal of scaffolds with ≥50% non-redundant organellar coverage.
- `2.GC_depth_assessment.sh` — GC content and HiFi sequencing-depth analysis in non-overlapping 10-kb windows.
- `3.Kraken2_screening` — Taxonomic screening using Kraken2 v2.1.2 and the PlusPFP-16 database (release 20260626).

## Supporting scripts

- `calculate_organelle_coverage.py` — Calculates combined chloroplast and mitochondrial coverage and identifies candidate scaffolds.
- `fasta_stats.py` — Calculates assembly statistics.
- `compare_before_after.py` — Compares assembly statistics before and after filtering.

## Supporting results

- `candidate_organelle_scaffolds.tsv` — Candidate organelle-derived scaffold identifiers and coverage statistics.
- `Ksch.final.clean.10kb.GC_depth.q20.tsv` — GC content and mean HiFi depth for 10-kb genomic windows.
- `Ksch.final.clean.kraken2.report` — Kraken2 taxonomic classification results.

## Summary

A total of 60 candidate organelle-derived scaffolds (3,312,179 bp) were removed, reducing the assembly from 521 scaffolds (988,689,271 bp) to 461 scaffolds (985,377,092 bp). Scaffold N50 remained unchanged at 104,900,589 bp. No additional scaffolds were removed following Kraken2 screening.

Detailed commands, software versions, and input–output relationships are provided in the corresponding workflow files.
