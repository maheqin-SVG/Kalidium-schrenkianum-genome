### Command

cat Ksch_L1_R1.fq.gz Ksch_L2_R1.fq.gz > Ksch_HiC_R1.fq.gz
cat Ksch_L1_R2.fq.gz Ksch_L2_R2.fq.gz > Ksch_HiC_R2.fq.gz

bwa index Ksch.asm.bp.p_ctg.fa
bwa mem -t 10 -5SP \
  Ksch.asm.bp.p_ctg.fa \
  Ksch_HiC_R1.fq.gz \
  Ksch_HiC_R2.fq.gz | \
samblaster | \
samtools view -@ 10 -S -h -b -F 3340 \
  -o Ksch_HiC.bam -

HapHiC/utils/filter_bam \
  Ksch_HiC.bam \
  1 --nm 3 --threads 14 | \
samtools view -b -@ 14 \
  -o Ksch_HiC.filtered.bam -

HapHiC/haphic pipeline \
  Ksch.asm.bp.p_ctg.fa \
  Ksch_HiC.filtered.bam \
  9 \
  --quick_view

HapHiC/utils/juicer pre \
  -a -q 1 \
  -o out_JBAT \
  Ksch_HiC.filtered.bam \
  scaffolds.raw.agp \
  Ksch.asm.bp.p_ctg.fa.fai \
  > out_JBAT.log 2>&1

java -Djava.awt.headless=true -Xmx32G \
  -jar juicer_tools.jar pre \
  out_JBAT.txt \
  out_JBAT.hic.part \
  <(grep PRE_C_SIZE out_JBAT.log | awk '{print $2" "$3}')

HapHiC/utils/juicer post \
  -o out_JBAT \
  out_JBAT.review.new.assembly \
  out_JBAT.liftover.agp \
  Ksch.asm.bp.p_ctg.fa

HapHiC/haphic plot \
  out_JBAT.FINAL.agp \
  Ksch_HiC.filtered.bam

### Software

- BWA-MEM v0.7.18-r1243
- SAMBLASTER v0.1.26
- SAMtools v1.6
- HapHiC v1.0.6
- Juicebox v1.11.08

### Input

- `Ksch.asm.bp.p_ctg.fa`
- `Ksch_L1_R1.fq.gz`
- `Ksch_L1_R2.fq.gz`
- `Ksch_L2_R1.fq.gz`
- `Ksch_L2_R2.fq.gz`

### Output

- `Ksch_HiC_R1.fq.gz`
- `Ksch_HiC_R2.fq.gz`
- `Ksch_HiC.bam`
- `Ksch_HiC.filtered.bam`
- `scaffolds.raw.agp`
- `out_JBAT.assembly`
- `out_JBAT.hic`
- `out_JBAT.review.new.assembly`
- `out_JBAT.FINAL.agp`
- `out_JBAT.FINAL.fa`

### Input–output relationship

The chromosome-scale assembly workflow consisted of three sequential steps:

1. **Hi-C read alignment and filtering**  
   Input: `Ksch.asm.bp.p_ctg.fa` and Hi-C paired-end reads  
   Output: `Ksch_HiC.bam` and `Ksch_HiC.filtered.bam`

2. **HapHiC scaffolding**  
   Input: `Ksch.asm.bp.p_ctg.fa` and `Ksch_HiC.filtered.bam`  
   Output: `scaffolds.raw.agp` and intermediate HapHiC scaffolding files

3. **Juicebox manual curation and assembly reconstruction**  
   The HapHiC scaffolding result was converted into Juicebox files (`out_JBAT.assembly` and `out_JBAT.hic`) for visual inspection and manual correction. 
   The manually reviewed assembly (`out_JBAT.review.new.assembly`) was subsequently processed using the HapHiC `juicer post` utility to reconstruct the Hi-C-curated chromosome-scale assembly (`out_JBAT.FINAL.agp` and `out_JBAT.FINAL.fa`). 
   Contamination removal was performed subsequently and is documented separately in `06-Contamination_assessment`.
