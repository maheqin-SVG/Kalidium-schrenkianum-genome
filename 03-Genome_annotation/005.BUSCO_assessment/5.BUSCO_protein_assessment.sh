### Command

busco \
  -i Ksch.clean.pep.fasta \
  -o Ksch_BUSCO_protein \
  -l embryophyta_odb12.2 \
  -m proteins \
  -c 32

find Ksch_BUSCO_protein \
  -type f \
  -name "short_summary*.txt" \
  -exec cat {} \; \
  > Ksch.BUSCO.protein_summary.txt

 ### Software

- BUSCO v6.1.0
- Lineage database: embryophyta_odb12.2

### Input

- `Ksch.clean.pep.fasta`

### Output

- `Ksch_BUSCO_protein/`
- `Ksch.BUSCO.protein_summary.txt`

### Input–output relationship

`Ksch.clean.pep.fasta`
→ BUSCO protein-mode assessment
→ protein-set completeness statistics and `Ksch.BUSCO.protein_summary.txt`
