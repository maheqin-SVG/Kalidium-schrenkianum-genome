### Command

omamer search \
  -d LUCA.h5 \
  -q Ksch.clean.pep.fasta \
  -o Ksch.final.clean.LUCA.omamer \
  -t 8 \
  --log_level info

omark \
  -f Ksch.final.clean.LUCA.omamer \
  -d LUCA.h5 \
  -o Ksch.final.clean.LUCA \
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

- `Ksch.final.clean.LUCA.omamer`
- `Ksch.final.clean.LUCA/`

### Input–output relationship

`Ksch.clean.pep.fasta`
→ OMAmer search against the LUCA database
→ `Ksch.final.clean.LUCA.omamer`
→ OMArk proteome assessment
→ completeness and taxonomic-consistency statistics
