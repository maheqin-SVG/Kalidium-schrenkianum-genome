# Genome annotation

This directory contains the scripts, configuration files, and summary results used for structural and functional annotation of the *Kalidium schrenkianum* genome.

### `001.Repeat_annotation`

Repeat sequence annotation:

- `1.Repeat_annotation.sh` — identification and annotation of repetitive elements

### `002.Gene_prediction`

Protein-coding gene prediction and evidence integration:

- `2.Gene_prediction.sh` — protein-coding gene prediction
- `EVM_commands.sh` — integration of gene models using EvidenceModeler (EVM)
- `conf_for_big_genome.txt` — configuration file used for gene prediction

### `003.Functional_annotation`

Functional annotation of predicted protein-coding genes:

- `3.Functional_annotation.sh` — functional annotation against multiple protein and functional databases

### `004.RNA_annotation`

RNA annotation:

- `4.RNA_annotation.sh` — identification and annotation of RNAs

### `005.BUSCO_assessment`

Completeness assessment of the predicted protein set:

- `5.BUSCO_protein_assessment.sh` — BUSCO assessment of predicted proteins
- `Ksch.BUSCO.protein_summary.txt` — summary of BUSCO protein completeness results

### `006.OMArk_assessment`

Quality and completeness assessment of the predicted proteome using OMArk:

- `6.OMArk_assessment.sh` — OMArk proteome assessment
- `Ksch.final.clean.LUCA_detailed_summary.txt` — detailed OMArk assessment results
