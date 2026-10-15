Source annotation recovery, from this directory:

1. Run `python fetch.py` to retrieve the cited GlyTouCan WURCS records.
2. Run `Rscript parse_glytoucan.R .` with glyparse and glyrepr installed.
3. Run `python reconcile.py` to compare additive source counts with registry counts.

The reviewed snapshot used glyparse 0.8.1 and glyrepr 1.1.0. Disputed source/registry annotations are retained in the audit records and are not silently resolved.
