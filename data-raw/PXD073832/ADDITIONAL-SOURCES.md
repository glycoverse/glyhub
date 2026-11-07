# PXD073832 original quantitative source assets

Load with `glyhub_load(dataset, kind="raw")`. This returns an unchanged source file, not instrument-raw data or a curated SE. SHA256, licences, mapping, original scale and limitations are in `source-assets-additional.json`.

Reproduce from the listed original files, preserving the relative directory names:

```sh
Rscript data-raw/PXD073832/build-additional-sources.R <source-directory> <cache>
```

## `glyhub_PXD073832_ConAEnrichedPrecursors_SourceQuantification`

[Original source](https://www.iprox.cn/page/project.html?id=IPX0013604000) · [Study](https://doi.org/10.1038/s41467-026-71524-7)

Full17655precursor×6run matrix, ordinary peptide precursors from ConA-enriched protein lysates, NOT intactN-glycopeptide/glycosite assignments. Protein-group ambiguity preserved.

Original linear author processed per-sample intensity/area, sourcezeros and blankmissing retained; no new normalization/imputation.

Exactcolumnfilebasenames P32L1/P32L2/P32L3 versus WT1/WT2/WT3 gastrocnemius muscle. Source precursorID and originalpathlabels retained.

Author supplementaryFig6h narrower16350rows is not used; independent complete deposit17655rows selected. No inferredglycosites from ordinary peptide sequences.
