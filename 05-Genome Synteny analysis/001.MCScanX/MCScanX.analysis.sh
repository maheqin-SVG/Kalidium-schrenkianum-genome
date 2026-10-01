#Command

for sp in Ksch Hara Bvul; do
  awk -F'\t' 'BEGIN{OFS="\t"}
  $3=="mRNA" {
      n=split($9,a,";");
      for(i=1;i<=n;i++){
          if(a[i] ~ /^ID=/){
              sub(/^ID=/,"",a[i]);
              print $1,a[i],$4,$5;
              break
          }
      }
  }' ${sp}.gff3 > ${sp}.mcscanx.gff
done

cat Ksch.mcscanx.gff \
    Hara.mcscanx.gff \
    Bvul.mcscanx.gff \
    > Ksch_Hara_Bvul.gff

cat Ksch.pep.fa \
    Hara.pep.fa \
    Bvul.pep.fa \
    > Ksch_Hara_Bvul.pep.fa

makeblastdb \
  -in Ksch_Hara_Bvul.pep.fa \
  -dbtype prot \
  -out Ksch_Hara_Bvul_blastdb

blastp \
  -query Ksch_Hara_Bvul.pep.fa \
  -db Ksch_Hara_Bvul_blastdb \
  -out Ksch_Hara_Bvul.blast \
  -evalue 1e-5 \
  -outfmt 6 \
  -num_threads 32

MCScanX Ksch_Hara_Bvul \
  -s 12 \
  -m 10 \
  -e 1e-10

#Software
- MCScanX v1.0.0
- NCBI BLAST+

#Input
- Ksch.gff3
- Hara.gff3
- Bvul.gff3
- Ksch.pep.fa
- Hara.pep.fa
- Bvul.pep.fa

#Output
- Ksch.mcscanx.gff
- Hara.mcscanx.gff
- Bvul.mcscanx.gff
- Ksch_Hara_Bvul.gff
- Ksch_Hara_Bvul.pep.fa
- Ksch_Hara_Bvul.blast
- Ksch_Hara_Bvul.collinearity
- Ksch_Hara_Bvul.tandem

#Input–output relationship
Protein sequences and GFF3 annotations from K. schrenkianum, H. arachnoideus, and B. vulgaris
→ preparation and combination of MCScanX gene-coordinate files
→ combination of protein sequences
→ all-vs-all BLASTP
→ MCScanX collinearity analysis with -s 12 -m 10 -e 1e-10
→ identification of collinear blocks and homologous gene-pair anchors
