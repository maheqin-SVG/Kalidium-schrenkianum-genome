#!/usr/bin/env python3

import sys
import gzip

fa = sys.argv[1]

def op(x):
    return gzip.open(x, "rt") if x.endswith(".gz") else open(x)

lengths = []
gc = 0
at = 0
n = 0
total = 0

seq = []

def process(s):
    global gc, at, n, total
    if not s:
        return
    s = "".join(s).upper()
    L = len(s)
    lengths.append(L)
    total += L
    gc += s.count("G") + s.count("C")
    at += s.count("A") + s.count("T")
    n += s.count("N")

with op(fa) as f:
    for line in f:
        if line.startswith(">"):
            process(seq)
            seq = []
        else:
            seq.append(line.strip())
    process(seq)

lengths.sort(reverse=True)

half = total / 2
cum = 0
n50 = None
l50 = None

for i, L in enumerate(lengths, 1):
    cum += L
    if cum >= half:
        n50 = L
        l50 = i
        break

denom = gc + at

print("Metric\tValue")
print(f"Number_of_sequences\t{len(lengths)}")
print(f"Total_length_bp\t{total}")
print(f"Total_length_Mb\t{total/1e6:.6f}")
print(f"Longest_sequence_bp\t{max(lengths) if lengths else 0}")
print(f"Shortest_sequence_bp\t{min(lengths) if lengths else 0}")
print(f"N50_bp\t{n50}")
print(f"L50\t{l50}")
print(f"GC_pct\t{gc/denom*100:.6f}" if denom else "GC_pct\tNA")
print(f"N_count\t{n}")
print(f"N_pct\t{n/total*100:.6f}" if total else "N_pct\tNA")
