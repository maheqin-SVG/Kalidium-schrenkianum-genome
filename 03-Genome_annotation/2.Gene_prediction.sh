#!/bin/bash
set -euo pipefail
GENOME="out_JBAT.FINAL.Ksch.fa"
RNA_R1="ksch-RNA_stem.r1.fq.gz,ksch-RNA_leaf.r1.fq.gz"
RNA_R2="ksch-RNA_stem.r2.fq.gz,ksch-RNA_leaf.r2.fq.gz"
PROTEIN="homolog.fasta"
PFAM_DB="Pfam-AB.hmm"
CONFIG="GETA_config.txt"
CPU=32

cat > "${CONFIG}" <<'EOF'
[RepeatMasker]
-e ncbi -gff
[trimmomatic]
TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50 TOPHRED33
[hisat2-build]
-p 1
[hisat2]
--min-intronlen 20 --max-intronlen 20000 --dta --score-min L,0.0,-0.4
[sam2transfrag]
--fraction 0.05 --min_expressed_base_depth 2 --max_expressed_base_depth 50 --min_junction_depth 2 --max_junction_depth 50 --min_fragment_count_per_transfrags 10 --min_intron_length 20
[TransDecoder.LongOrfs]
-m 100 -G universal
[TransDecoder.Predict]
--retain_long_orfs_mode dynamic
[homolog_genewise]
--coverage_ratio 0.4 --evalue 1e-9
[homolog_genewiseGFF2GFF3]
--min_score 15 --gene_prefix genewise --filterMiddleStopCodon
[geneModels2AugusutsTrainingInput]
--min_evalue 1e-9 --min_identity 0.8 --min_coverage_ratio 0.6 --min_cds_num 2 --min_cds_length 600 --min_cds_exon_ratio 0.60
[BGM2AT]
--min_gene_number_for_augustus_training 500 --gene_number_for_accuracy_detection 200 --min_gene_number_of_optimize_augustus_chunk 50 --max_gene_number_of_optimize_augustus_chunk 200
[prepareAugusutusHints]
--margin 20
[paraAugusutusWithHints]
--gene_prefix augustus --min_intron_len 30 --alternatives_from_evidence
[paraCombineGeneModels]
--overlap 30 --min_augustus_transcriptSupport_percentage 50.0 --min_augustus_intronSupport_number 1 --min_augustus_intronSupport_ratio 0.5
[PfamValidateABinitio]
--CDS_length 1200 --CDS_num 4 --evalue 1e-9 --coverage 0.4
[remove_genes_in_repeats]
--ratio 0.6
[remove_short_genes]
--cds_length 300
EOF

geta.pl \
    --RM_species Viridiplantae \
    --genome "${GENOME}" \
    -1 "${RNA_R1}" \
    -2 "${RNA_R2}" \
    --protein "${PROTEIN}" \
    --augustus_species Ksch \
    --cpu "${CPU}" \
    --out_prefix Ksch \
    --gene_prefix Ksch \
    --config "${CONFIG}" \
    --pfam_db "${PFAM_DB}"
