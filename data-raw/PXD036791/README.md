# PXD036791: GALNT O-glycopeptide reporter experiments

```sh
Rscript data-raw/PXD036791/build.R /path/to/supplements /path/to/cache
```

Run from the package root. Retrieve Supplementary Data 2 using the archive URL,
member name and SHA-256 in `sources.json`. The builder reads that exact file
without network requests and leaves generated RDS files in ignored staging.

Nine total-cell-lysate experiments are stored in one **6,789-by-54** object,
`glyhub_PXD036791_O_GALNT_TCL`, while retaining nine distinct TMT batches.
Exact alignment uses Identifier, Accessions, GlycoSite, GlyNum, GlycanType,
Sequence, Modi and Theo MHplus in Da. Identifier alone or keys omitting mass
would conflate source variants; no mass tolerance or inferred modification is
used. The 121,872 original cells are unchanged; 244,734 newly absent cells are
structural NA, distinct from original NA and zeros. Twenty-three merged keys
have conflicting Gene annotations: the consensus is unknown and all original
labels remain available. WT technical measurements and KO clone metadata stay
experiment-specific; storage alignment is not cross-batch normalization.

`metadata(x)$source_experiments` preserves complete original objects. Source
row/column maps support exact per-experiment roundtrips; the four processing
masks distinguish coverage, structural missingness, native missingness and zeros.
`merged-resource-map.json` maps the nine superseded unpublished identifiers to
the canonical object and experiment selector. They are not silent loader aliases.

The two secretome sheets represent **one** sixplex. The author raw-file/channel
description and exact Identifier/Sequence/site/glycan keys establish the shared
experiment. WT 126/127 values are checked for exact equality before retaining
them once, followed by GALNT1-KO 128/129 and GALNT2-KO 130/131. The complete
987-by-6 result retains both source missing cells. No averaging occurs.

Source values already have total-peptide-level normalization. No further
normalization, log transformation, filtering or imputation is added. Authors
copied a multisite peptide's signal to its constituent sites; those rows are
flagged and must not be treated as independent site quantifications. Original
T/Tn labels, modifications, accessions and statistical annotations are retained.
No linkage structures are inferred.

Article and actual Data 7 name PXD036791; a stale description mentions PXD031998.
This discrepancy is retained rather than creating a duplicate source project.
Total-proteome controls, significance-filtered target lists, categorical
occupancy tables and other-publication comparisons are not new glyco matrices.

The selected original-author measurement tables accompany a CC BY 4.0 article,
with no separate exclusion identified in those tables. Attribution, source links,
license evidence and adaptation description remain in the provenance.
`validation.json` records exact comparison of all 127,794 source cells across
the two active objects (nine lysate batches plus one secretome). Each receipt pins the staged asset; no release is published.
