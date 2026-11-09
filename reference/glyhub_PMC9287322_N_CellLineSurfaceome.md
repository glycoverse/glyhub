# Cell-surface-capture protein panel CellLineSurfaceome

Cell-surface-capture protein panel CellLineSurfaceome

## Usage

``` r
glyhub_PMC9287322_N_CellLineSurfaceome(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 1453 source rows and 35 measurements.

## Source

<https://doi.org/10.1038/s41467-022-31810-6>. CC BY 4.0 author
supplement; see license_evidence.json

## Arguments

- kind:

  `"curated"` returns a data object; `"raw"` returns the path to a
  verified source file. Here `"raw"` means the source asset, not
  necessarily instrument-raw or unprocessed intensity. Some literature
  sources contain signed author-processed matrices and have no curated
  object.

- cache_dir:

  Cache directory, defaulting to `tools::R_user_dir("glyhub", "cache")`.
  Set option `glyhub.cache_dir` to change the default.

- refresh:

  Download the pinned resource again, even if cached.

- offline:

  Prohibit downloads; require a verified local resource.

## Details

Preserve complete selected author-processed matrix on its supplied log2
LFQ scale; no new filtering, imputation or transformation. Same
study/source family, not independent cohorts. CellLineSurfaceome partly
reuses PXD016800 leukemia data; exact shared-control run overlap across
panels unresolved because official sample-list downloads failed.
Original sample labels, patient input titration and methods preserved;
do not infer independence. Preserve every author row, including repeated
protein labels; do not deduplicate or infer quantified glycans/sites.
These panels share a study source family and are not independent
cohorts; accession mapping is retained per source table.

Source scale: author log2 LFQ protein surfaceome abundance.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Available from the versioned `data-v0.2.0` GitHub data release.
Downloads are verified by file size and SHA-256 and cached for offline
reuse.
