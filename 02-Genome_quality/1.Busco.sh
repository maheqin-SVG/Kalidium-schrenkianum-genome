### Command

mv Ksch_new_clean.FINAL.fa Ksch.final.clean.fa

busco \
  -i Ksch.final.clean.fa \
  -o busco_output_ksch \
  -l embryophyta_odb12.2 \
  -m genome \
  -c 16

find busco_output_ksch \
  -type f \
  -name "short_summary*.txt" \
  -exec cat {} \; \
  > Ksch.BUSCO.full_summary.txt
  
### Software

- BUSCO v6.1.0
- Lineage database: embryophyta_odb12.2

### Input

- `Ksch.final.clean.fa`

### Output

- `busco_output_ksch/`
- `Ksch.BUSCO.full_summary.txt`

### Input–output relationship

`Ksch.final.clean.fa`
→ `busco_output_ksch/`
→ `Ksch.BUSCO.full_summary.txt`

The final genome assembly was evaluated in genome mode using BUSCO v6.1.0 with the `embryophyta_odb12.2` lineage dataset. 
The BUSCO output directory contains the detailed assessment results, and the short summary file was collected as `Ksch.BUSCO.full_summary.txt` for reporting and repository archiving.
