### Command

omamer search \
  -d LUCA.h5 \
  -q Ksch.clean.pep.fasta \
  -o Ksch.LUCA.omamer \
  -t 8 \
  --log_level info

omark \
  -f Ksch.LUCA.omamer \
  -d LUCA.h5 \
  -o Ksch_OMArk_LUCA \
  -of Ksch.clean.pep.fasta \
  -v
  
### Software

- OMArk v0.5.0
- OMAmer
- OMAmer LUCA database: `LUCA.h5`

### Input

- `Ksch.clean.pep.fasta`
- `LUCA.h5`

### Output

- `Ksch.LUCA.omamer`
- `Ksch_OMArk_LUCA/`

### Input–output relationship

`Ksch.clean.pep.fasta`
→ OMAmer search against the LUCA database
→ `Ksch.LUCA.omamer`
→ OMArk proteome assessment
→ completeness and taxonomic-consistency statistics
