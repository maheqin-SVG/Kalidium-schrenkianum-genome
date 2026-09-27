### Command

EDTA.pl \
  --genome Ksch.final.clean.fa \
  --sensitive 1 \
  --anno 1 \
  --threads 32
  
### Software

- EDTA v2.1.0

### Input

- `Ksch.final.clean.fa`

### Output

- `Ksch.final.clean.fa.mod.EDTA.TElib.fa`
- `Ksch.final.clean.fa.mod.EDTA.TEanno.gff3`
- `Ksch.final.clean.fa.mod.EDTA.TEanno.sum`
- `Ksch.final.clean.fa.mod.EDTA.intact.fa`
- `Ksch.final.clean.fa.mod.EDTA.intact.gff3`

### Input–output relationship

`Ksch.final.clean.fa`
→ non-redundant TE library
→ genome-wide TE annotation
→ intact TE annotations

The final contamination-cleaned genome assembly (`Ksch.final.clean.fa`) was used as the input for repeat annotation with EDTA v2.1.0. 
EDTA performed de novo identification and classification of major transposable element families and generated a non-redundant TE library together with genome-wide TE annotations. 
