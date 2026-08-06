Kalidium-schrenkianum-genome

Scripts for the manuscript “A chromosome-scale genome assembly of the halophyte Kalidium schrenkianum”, currently under review at Scientific Data.

This repository contains the major scripts used for genome assembly, genome quality assessment, genome annotation, LTR-retrotransposon insertion-time analysis, and comparative genome synteny analysis of Kalidium schrenkianum. Detailed command-line parameters and analysis settings are provided in the corresponding scripts.

01-Genome assembly

This section contains scripts for PacBio HiFi de novo assembly and Hi-C-based chromosome scaffolding of the K. schrenkianum genome.

1. HiFi_assembly.sh - Script to convert PacBio HiFi reads from BAM to FASTA format, perform de novo genome assembly using hifiasm, and extract the primary contig assembly.

2. HiC_scaffolding.sh - Script to map and filter Hi-C reads, perform chromosome scaffolding using HapHiC, generate files for Juicebox visualization, manually curate chromosome scaffolds, and produce the final chromosome-scale genome assembly.


02-Genome quality assessment

This section contains scripts to evaluate the completeness and sequence accuracy of the final K. schrenkianum genome assembly.

1. Busco.sh - Script to evaluate genome assembly completeness using BUSCO and report complete single-copy, duplicated, fragmented, and missing conserved orthologs.

2. QV.sh - Script to evaluate genome consensus quality and k-mer completeness using Illumina reads, Meryl, and Merqury.


03-Genome annotation

This section contains scripts for transposable-element annotation, protein-coding gene prediction, functional annotation, non-coding RNA annotation, and assessment of the predicted protein-coding gene set.

1. Repeat_annotation.sh - Script to identify and annotate transposable elements across the K. schrenkianum genome using EDTA, including intact LTR-retrotransposons.

2. Gene_prediction.sh - Script to predict protein-coding genes by integrating RNA-seq evidence, homologous protein evidence, ab initio gene prediction, and protein-domain information using the GETA pipeline.

3. Functional_annotation.sh - Script to functionally annotate predicted proteins using InterProScan, Gene Ontology, Swiss-Prot, NCBI NR, KOG, and KEGG databases.

4. ncRNA_annotation.sh - Script to annotate non-coding RNAs, including Rfam-associated ncRNAs, tRNAs, and 5S, 5.8S, 18S, and 28S rRNAs.

5. BUSCO_protein_assessment.sh - Script to evaluate the completeness of the predicted protein-coding gene set using BUSCO in protein mode.

6. OMArk_assessment.sh - Script to independently evaluate the completeness, duplication, phylogenetic consistency, and potential contamination of the predicted proteome using OMArk and the LUCA database.


04-LTR-retrotransposon insertion-time analysis

This section contains scripts to estimate the insertion-time distribution of intact Copia and Gypsy LTR-retrotransposons.

1. LTR_identity_extraction.sh - Script to extract Copia and Gypsy LTR-retrotransposons and their paired-LTR identity values from the EDTA intact-LTR annotation.

2. LTR_insertion_time_plot.R - R script to calculate LTR-retrotransposon insertion times from paired-LTR sequence identity, summarize insertion-time distributions, and generate density plots for Copia and Gypsy elements.


05-Genome synteny analysis

This section contains the workflow for comparative chromosome-level synteny analysis among Haloxylon arachnoideus, Kalidium schrenkianum, and Beta vulgaris.

1. Synteny_analysis.sh - Script to prepare gene coordinate and CDS files, identify pairwise syntenic anchors, filter syntenic blocks, and generate chromosome-level synteny plots among H. arachnoideus, K. schrenkianum, and B. vulgaris.


06-Contamination assessment

This section contains scripts to assess potential organellar contamination and the overall purity of the K. schrenkianum genome assembly.

1.organelle_contamination_screening.sh - Script to assemble chloroplast and mitochondrial genomes from PacBio HiFi reads, align the organellar genomes against the genome assembly, calculate organellar sequence coverage, and remove candidate organelle-derived scaffolds with ≥50% organellar coverage.

2.GC_depth_assessment.sh - Script to map PacBio HiFi reads to the organelle-filtered assembly, retain alignments with mapping quality ≥20, and calculate mean sequencing depth and GC content in non-overlapping 10-kb windows for GC–depth-based assessment of assembly purity.
