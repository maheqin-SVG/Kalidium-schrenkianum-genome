import pandas as pd

root = "/groups/g1600002/home/mahq2025/maheqin/workspace/01.hic/Ksch/19.final.remove_pollutation"

b = pd.read_csv(
    f"{root}/05.statistics/assembly.before_removal.tsv",
    sep="\t"
)

a = pd.read_csv(
    f"{root}/05.statistics/assembly.after_removal.tsv",
    sep="\t"
)

b.columns = ["Metric","Before_removal"]
a.columns = ["Metric","After_removal"]

out = b.merge(a,on="Metric",how="outer")

out.to_csv(
    f"{root}/05.statistics/assembly_before_after.tsv",
    sep="\t",
    index=False
)

print(out.to_string(index=False))
