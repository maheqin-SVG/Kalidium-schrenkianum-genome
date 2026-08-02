# Kalidium-schrenkianum-genome

Scripts for the manuscript **“A chromosome-scale genome assembly of the halophyte *Kalidium schrenkianum*”**.

This repository contains the major scripts, workflows, and command-line parameters used for genome assembly, quality assessment, genome annotation, LTR-retrotransposon insertion-time analysis, and comparative genome synteny analysis of *Kalidium schrenkianum*. Server-specific paths have been replaced with generic paths where appropriate to improve reproducibility.

## 01. Genome assembly

This section contains scripts for PacBio HiFi de novo assembly and Hi-C-based chromosome scaffolding of the *K. schrenkianum* genome.

**1.HiFi_assembly.sh** - Script to convert PacBio HiFi reads from BAM to FASTA and perform de novo genome assembly using hifiasm with 20 threads. Primary contigs were extracted from the hifiasm `*.bp.p_ctg.gfa` output.

**2.HiC_scaffolding.sh** - Script for Hi-C read mapping, filtering, and chromosome scaffolding using BWA-MEM, samblaster, SAMtools, HapHiC, and Juicebox. Hi-C reads were mapped with BWA-MEM `-5SP`, filtered using `-F 3340`, MAPQ ≥ 1 and `--nm 3`, and scaffolded using HapHiC with `--quick_view`. The resulting scaffolds were manually inspected and corrected in Juicebox before generating the final chromosome-scale assembly.

## 02. Genome quality assessment

This section contains scripts for evaluating the completeness and consensus accuracy of the final genome assembly.

**1.Busco.sh** - Script to assess genome completeness using **BUSCO v6.1.0** in genome mode with the **embryophyta_odb12.2** lineage dataset. Complete single-copy, duplicated, fragmented, and missing BUSCO statistics were retained.

**2.QV.sh** - Script to evaluate assembly consensus quality value (QV) and k-mer completeness using Merqury and Meryl. A k-mer size of **k = 21** was selected based on the estimated genome size of 934,011,618 bp, and paired-end Illumina reads were used to construct the reference-free k-mer database.

## 03. Genome annotation

This section contains scripts for repeat annotation, protein-coding gene prediction, functional annotation, non-coding RNA annotation, and quality assessment of the predicted protein set.

**1.Repeat_annotation.sh** - Script for transposable-element annotation using **EDTA v2.1.0** with `--sensitive 1`, `--anno 1`, and 64 threads. The resulting annotation includes genome-wide TEs and intact LTR-retrotransposons.

**2.Gene_prediction.sh** - Script for protein-coding gene prediction using **GETA v2.4.12**, integrating RNA-seq, homologous protein, ab initio, and Pfam evidence. The workflow includes HISAT2 v2.1.0, AUGUSTUS v3.3.3, GeneWise v2.4.1, HMMER v3.4, MAFFT v7.490, and other supporting tools. The complete GETA parameter configuration used for gene prediction is included directly in the script.

**3.Functional_annotation.sh** - Script for functional annotation of predicted proteins using **InterProScan v5.52-86.0**, GO, UniProtKB/Swiss-Prot, NCBI NR, KOG, and KEGG. Swiss-Prot and KOG searches were performed using **BLAST+ v2.13.0** with `E-value ≤ 1e-5`, whereas NR searches were performed using DIAMOND in `--more-sensitive` mode with `--id 30` and `--evalue 1e-5`. KEGG Orthology assignments were obtained using KAAS.

**4.ncRNA_annotation.sh** - Script for non-coding RNA annotation using Infernal/Rfam, tRNAscan-SE, and BLASTN. Rfam ncRNAs were identified using `cmscan`, tRNAs were predicted using tRNAscan-SE, and 5S, 5.8S, 18S, and 28S rRNAs were identified using **BLAST+ v2.14** with `E-value ≤ 1e-10` and sequence identity ≥ 85%.

**5.BUSCO_protein_assessment.sh** - Script to assess completeness of the predicted protein-coding gene set using **BUSCO v6.1.0** in protein mode with the **embryophyta_odb12.2** lineage dataset.

**6.OMArk_assessment.sh** - Script for independent evaluation of predicted proteome completeness, unexpected duplication, and potential contamination using **OMArk v0.5.0** and the **LUCA** hierarchical orthologous group database.

## 04. LTR-RT insertion time

This section contains scripts for estimating the insertion-time distribution of intact Copia and Gypsy LTR-retrotransposons.

**1.LTR_identity_extraction.sh** - Script to extract intact `LTR/Copia` and `LTR/Gypsy` elements and their paired-LTR identity values from the EDTA intact-LTR GFF3 annotation.

**2.LTR_insertion_time_plot.R** - R script to calculate LTR-retrotransposon insertion times using `T = K / (2μ)`, where `K = 1 - LTR identity` and `μ = 7.54 × 10^-9 substitutions/site/year`. The script summarizes Copia and Gypsy insertion times and generates density plots using ggplot2.

## 05. Genome synteny analysis

This section contains the workflow for comparative chromosome-level synteny analysis among *Haloxylon arachnoideus*, *Kalidium schrenkianum*, and *Beta vulgaris*.

**Synteny_analysis.sh** - Script to prepare BED and CDS files, identify pairwise syntenic anchors, filter syntenic blocks, and generate chromosome-level synteny plots using **JCVI v1.0.5**. Pairwise anchors were identified using `jcvi.compara.catalog ortholog --no_strip_names`, and syntenic blocks were filtered using `jcvi.compara.synteny screen --minspan=30 --simple`. The final karyotype plot displays Hara–Ksch and Ksch–Bvul syntenic relationships, with *B. vulgaris* positioned below *K. schrenkianum* and horizontally reversed to improve ribbon visualization.

## Main software

Major software used in this repository includes:

- BUSCO v6.1.0
- EDTA v2.1.0
- GETA v2.4.12
- HISAT2 v2.1.0
- AUGUSTUS v3.3.3
- GeneWise v2.4.1
- HMMER v3.4
- MAFFT v7.490
- InterProScan v5.52-86.0
- NCBI BLAST+ v2.10.0–2.14
- OMArk v0.5.0
- JCVI v1.0.5
- hifiasm
- HapHiC
- Merqury
- Meryl
- Infernal
- tRNAscan-SE
- DIAMOND
- SeqKit
- BEDTools
- R/ggplot2

Additional software versions and database releases can be obtained from the corresponding scripts or original computational environments.
