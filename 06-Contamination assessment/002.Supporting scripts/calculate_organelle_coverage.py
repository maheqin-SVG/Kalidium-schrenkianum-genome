#!/usr/bin/env python3

from collections import defaultdict
import csv

FAI = "ksch_genome.fasta.fai"

CP_BED = "03.coverage/chloroplast.merged.bed"
MT_BED = "03.coverage/mitochondrial.merged.bed"

OUT_UNION_BED = "03.coverage/all_organelle.merged.bed"
OUT_TABLE = "03.coverage/all_scaffold_organelle_coverage.tsv"
OUT_REMOVE = "03.coverage/candidate_organelle_scaffolds.tsv"
OUT_REMOVE_IDS = "03.coverage/remove_scaffolds.ids"

THRESHOLD = 0.50


# ============================================================
# 1. Read scaffold lengths
# ============================================================

scaffold_length = {}

with open(FAI) as f:
    for line in f:
        x = line.rstrip().split("\t")
        scaffold_length[x[0]] = int(x[1])


# ============================================================
# 2. Read BED
# ============================================================

def read_bed(filename):
    data = defaultdict(list)

    with open(filename) as f:
        for line in f:
            if not line.strip():
                continue

            x = line.rstrip().split("\t")

            chrom = x[0]
            start = int(x[1])
            end = int(x[2])

            data[chrom].append((start, end))

    return data


cp = read_bed(CP_BED)
mt = read_bed(MT_BED)


# ============================================================
# 3. Merge intervals
# ============================================================

def merge_intervals(intervals):

    if not intervals:
        return []

    intervals = sorted(intervals)

    merged = []

    cur_start, cur_end = intervals[0]

    for start, end in intervals[1:]:

        if start <= cur_end:
            cur_end = max(cur_end, end)

        else:
            merged.append((cur_start, cur_end))
            cur_start, cur_end = start, end

    merged.append((cur_start, cur_end))

    return merged


def covered_bp(intervals):
    return sum(end - start for start, end in intervals)


# ============================================================
# 4. Calculate coverage
# ============================================================

rows = []

all_scaffolds = sorted(
    scaffold_length.keys(),
    key=lambda x: scaffold_length[x],
    reverse=True
)

union_bed_lines = []

for scaffold in all_scaffolds:

    length = scaffold_length[scaffold]

    cp_intervals = merge_intervals(cp.get(scaffold, []))
    mt_intervals = merge_intervals(mt.get(scaffold, []))

    cp_bp = covered_bp(cp_intervals)
    mt_bp = covered_bp(mt_intervals)

    all_intervals = cp_intervals + mt_intervals

    union_intervals = merge_intervals(all_intervals)

    total_bp = covered_bp(union_intervals)

    for start, end in union_intervals:
        union_bed_lines.append(
            (scaffold, start, end)
        )

    cp_pct = cp_bp / length * 100
    mt_pct = mt_bp / length * 100
    total_pct = total_bp / length * 100

    decision = (
        "REMOVE"
        if total_bp / length >= THRESHOLD
        else "KEEP"
    )

    rows.append({
        "Scaffold": scaffold,
        "Scaffold_length_bp": length,
        "Chloroplast_covered_bp": cp_bp,
        "Chloroplast_coverage_pct": cp_pct,
        "Mitochondrial_covered_bp": mt_bp,
        "Mitochondrial_coverage_pct": mt_pct,
        "Total_organelle_covered_bp": total_bp,
        "Total_organelle_coverage_pct": total_pct,
        "Decision": decision
    })


# ============================================================
# 5. Write union BED
# ============================================================

with open(OUT_UNION_BED, "w") as out:
    for scaffold, start, end in union_bed_lines:
        out.write(
            f"{scaffold}\t{start}\t{end}\n"
        )


# ============================================================
# 6. Sort output by total organelle coverage
# ============================================================

rows = sorted(
    rows,
    key=lambda x: (
        x["Total_organelle_coverage_pct"],
        x["Scaffold_length_bp"]
    ),
    reverse=True
)


# ============================================================
# 7. Write complete table
# ============================================================

header = [
    "Scaffold",
    "Scaffold_length_bp",
    "Chloroplast_covered_bp",
    "Chloroplast_coverage_pct",
    "Mitochondrial_covered_bp",
    "Mitochondrial_coverage_pct",
    "Total_organelle_covered_bp",
    "Total_organelle_coverage_pct",
    "Decision"
]

with open(OUT_TABLE, "w", newline="") as out:

    writer = csv.DictWriter(
        out,
        fieldnames=header,
        delimiter="\t"
    )

    writer.writeheader()

    for row in rows:

        row2 = row.copy()

        row2["Chloroplast_coverage_pct"] = (
            f"{row['Chloroplast_coverage_pct']:.6f}"
        )

        row2["Mitochondrial_coverage_pct"] = (
            f"{row['Mitochondrial_coverage_pct']:.6f}"
        )

        row2["Total_organelle_coverage_pct"] = (
            f"{row['Total_organelle_coverage_pct']:.6f}"
        )

        writer.writerow(row2)


# ============================================================
# 8. Candidate removal table
# ============================================================

remove_rows = [
    x for x in rows
    if x["Decision"] == "REMOVE"
]

with open(OUT_REMOVE, "w", newline="") as out:

    writer = csv.DictWriter(
        out,
        fieldnames=header,
        delimiter="\t"
    )

    writer.writeheader()

    for row in remove_rows:

        row2 = row.copy()

        row2["Chloroplast_coverage_pct"] = (
            f"{row['Chloroplast_coverage_pct']:.6f}"
        )

        row2["Mitochondrial_coverage_pct"] = (
            f"{row['Mitochondrial_coverage_pct']:.6f}"
        )

        row2["Total_organelle_coverage_pct"] = (
            f"{row['Total_organelle_coverage_pct']:.6f}"
        )

        writer.writerow(row2)


# ============================================================
# 9. Remove IDs
# ============================================================

with open(OUT_REMOVE_IDS, "w") as out:
    for row in remove_rows:
        out.write(row["Scaffold"] + "\n")


# ============================================================
# 10. Screen summary
# ============================================================

print("=" * 100)
print("Organelle contamination screening summary")
print("=" * 100)

print(
    f"Total scaffolds in genome : "
    f"{len(scaffold_length)}"
)

print(
    f"REMOVE threshold          : "
    f">= {THRESHOLD*100:.1f}%"
)

print(
    f"Candidate scaffolds       : "
    f"{len(remove_rows)}"
)

remove_length = sum(
    x["Scaffold_length_bp"]
    for x in remove_rows
)

print(
    f"Candidate total length    : "
    f"{remove_length:,} bp"
)

print(
    f"Candidate total length    : "
    f"{remove_length/1e6:.6f} Mb"
)

print()
print("=" * 100)
print("Candidate organelle-derived scaffolds")
print("=" * 100)

print(
    "Scaffold\tLength\tCP%\tMT%\tTotal%\tDecision"
)

for x in remove_rows:

    print(
        f"{x['Scaffold']}\t"
        f"{x['Scaffold_length_bp']}\t"
        f"{x['Chloroplast_coverage_pct']:.2f}\t"
        f"{x['Mitochondrial_coverage_pct']:.2f}\t"
        f"{x['Total_organelle_coverage_pct']:.2f}\t"
        f"{x['Decision']}"
    )
