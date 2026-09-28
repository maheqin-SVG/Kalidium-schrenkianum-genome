### Command

# InterProScan annotation
interproscan.sh \
  -i ksch.pep.flt \
  -f tsv \
  -o Ksch.interproscan.tsv \
  -iprlookup \
  -goterms \
  -pa \
  -t p

# Swiss-Prot annotation
makeblastdb \
  -in uniprot_sprot.fasta \
  -dbtype prot \
  -out uniprot_sprot

blastp \
  -query ksch.pep \
  -db uniprot_sprot \
  -out Ksch.swissprot.out \
  -evalue 1e-5 \
  -outfmt 7

# NR annotation
diamond blastp \
  --db nr.dmnd \
  --query ksch.pep.flt \
  --out Ksch.nr.out \
  --outfmt 6 \
  --more-sensitive \
  --max-target-seqs 500 \
  --evalue 1e-5 \
  --id 30

# KOG annotation
makeblastdb \
  -in kyva \
  -dbtype prot \
  -out kog

blastp \
  -query ksch.pep \
  -db kog \
  -out Ksch.kog.out \
  -evalue 1e-5 \
  -outfmt 7

# KEGG annotation
# KO assignments were obtained using the KEGG KAAS web server.

### Software

- InterProScan v5.52-86.0
- DIAMOND v2.0.15
- KOBAS
- KEGG KAAS

### Input

- `Ksch.clean.pep.fasta`
- `uniprot_sprot.fasta`
- `nr.dmnd`
- `kyva`
- KEGG KAAS database
- InterPro databases

### Output

- `Ksch.interproscan.tsv`
- `Ksch.swissprot.out`
- `Ksch.nr.out`
- `Ksch.kog.out`
- `kegg.out`
- `InterPro.annotated_genes.txt`
- `GO.annotated_genes.txt`
- `SwissProt.annotated_genes.txt`
- `NR.annotated_genes.txt`
- `KOG.annotated_genes.txt`
- `KEGG.annotated_genes.txt`

### Input–output relationship

`Ksch.clean.pep.fasta`
→ functional annotation against InterPro, Swiss-Prot, NR, KOG, and KEGG databases
→ protein-domain, GO, sequence-similarity, and KEGG orthology annotations

The predicted protein sequences were functionally annotated against multiple protein and domain databases. 
InterProScan was used to identify conserved protein domains and associated InterPro/GO terms, 
while sequence-similarity searches against Swiss-Prot, NR, and KOG provided additional functional assignments. KEGG orthology assignments were obtained using the KEGG KAAS server.
