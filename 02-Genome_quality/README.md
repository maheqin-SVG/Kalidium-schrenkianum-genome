# Genome quality assessment

This directory contains the scripts and summary results used to assess the completeness and consensus quality of the *Kalidium schrenkianum* genome assembly.

### `001.Busco`

Genome completeness assessment using BUSCO:

- `1.Busco.sh` — BUSCO genome completeness assessment
- `Ksch.BUSCO.full_summary.txt` — summary of BUSCO completeness results

### `002.QV`

Reference-free assessment of genome consensus quality and completeness:

- `2.QV.sh` — genome quality assessment
- `Ksch.qv` — genome consensus quality value (QV)
- `Ksch.completeness.stats` — k-mer-based assembly completeness statistics
