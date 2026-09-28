### Command

# Rfam / Infernal annotation
cmpress Rfam.cm

cmscan \
  -Z 1900 \
  --cut_ga \
  --rfam \
  --nohmmonly \
  --fmt 2 \
  --tblout Ksch.Rfam.tblout \
  -o Ksch.Rfam.result \
  --clanin Rfam.clanin \
  Rfam.cm \
  Ksch.final.clean.fa

perl infernal-tblout2gff.pl \
  --cmscan \
  --fmt2 \
  Ksch.Rfam.tblout \
  > Ksch.Rfam.ncRNA.gff3

# tRNA annotation
tRNAscan-SE \
  Ksch.final.clean.fa \
  -o Ksch.tRNA.out \
  -f Ksch.tRNA.ss \
  -m Ksch.tRNA.stats

# rRNA annotation
makeblastdb \
  -in Ksch.final.clean.fa \
  -dbtype nucl \
  -parse_seqids \
  -out Ksch_genome

for TYPE in 5S 5.8S 18S 28S; do
  blastn \
    -query Sole.${TYPE}.fasta \
    -db Ksch_genome \
    -out Ksch.${TYPE}.rRNA.blast.out \
    -outfmt 6 \
    -evalue 1e-10 \
    -num_threads 8
done

### Software

- INFERNAL v1.1.5
- Rfam v15.0
- tRNAscan-SE v2.0.12
- BLASTN v2.12.0
- BEDTools v2.26.0

### Input

- `Ksch.final.clean.fa`
- `Rfam.cm`
- `Rfam.clanin`
- `Sole.5S.fasta`
- `Sole.5.8S.fasta`
- `Sole.18S.fasta`
- `Sole.28S.fasta`

### Output

- `Ksch.Rfam.tblout`
- `Ksch.Rfam.result`
- `Ksch.Rfam.ncRNA.gff3`
- `Ksch.tRNA.out`
- `Ksch.tRNA.ss`
- `Ksch.tRNA.stats`
- `Ksch.5S.rRNA.gff3`
- `Ksch.5.8S.rRNA.gff3`
- `Ksch.18S.rRNA.gff3`
- `Ksch.28S.rRNA.gff3`
- `Ksch.rRNA.gff3`

### Input–output relationship

`Ksch.final.clean.fa`
→ ncRNA annotation using Rfam/INFERNAL, tRNAscan-SE, and BLASTN-based rRNA identification
→ ncRNA, tRNA, and rRNA annotation files

The final contamination-cleaned genome assembly was used for non-coding RNA annotation. 
Rfam/INFERNAL was used to identify structured ncRNAs, tRNAscan-SE was used to predict tRNAs, and BLASTN searches against reference rRNA sequences were used to identify rRNA loci.
