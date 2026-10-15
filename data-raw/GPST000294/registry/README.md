# Source-linked GlyTouCan structures

Twelve accessions are printed explicitly in Supplementary Table S1. The pinned query response stores their WURCS sequences. Parsed structures were matched to the corresponding source diagrams and composition categories before use; other rows do not inherit these linkages by analogy.

To reparse the stored WURCS evidence with glyparse and glyrepr installed, run from the package root:

```sh
Rscript data-raw/GPST000294/registry/parse_glytoucan.R data-raw/GPST000294/registry
```

The source publication and the registry identifiers are retained in each affected feature's annotation. Registry evidence adds detail only where the author provided that identifier and the diagram agrees.
