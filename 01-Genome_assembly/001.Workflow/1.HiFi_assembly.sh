### Command

samtools view Ksch.hifi_reads.bam | \
awk '{print ">"$1"\n"$10}' > Ksch.hifi_reads.fasta

hifiasm -o Ksch.asm -t 20 Ksch.hifi_reads.fasta \
  2> Ksch.asm.log

awk '/^S/{print ">"$2"\n"$3}' \
  Ksch.asm.bp.p_ctg.gfa > Ksch.asm.bp.p_ctg.fa

samtools faidx Ksch.asm.bp.p_ctg.fa

### Software

- Hifiasm v0.16.1-r375
- SAMtools v1.6

### Input

- `Ksch.hifi_reads.bam`  
  
### Output

- `Ksch.hifi_reads.fasta`  

- `Ksch.asm.bp.p_ctg.gfa`  

- `Ksch.asm.bp.p_ctg.fa`  

### Input–output relationship

`Ksch.hifi_reads.bam`
→ `Ksch.hifi_reads.fasta`
→ `Ksch.asm.bp.p_ctg.gfa`
→ `Ksch.asm.bp.p_ctg.fa`
→ Hi-C scaffolding

The Hifiasm primary-contig assembly (`Ksch.asm.bp.p_ctg.gfa`) was retained and converted to FASTA format (`Ksch.asm.bp.p_ctg.fa`) for subsequent Hi-C scaffolding.
