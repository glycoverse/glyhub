# C1GALT1Silencing

C1GALT1Silencing

## Usage

``` r
glyhub_PMC9306173_O_C1GALT1Silencing(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 117 source rows and 6 measurements.

## Source

<https://doi.org/10.1186/s13046-022-02438-7>. CC BY4.0 author
supplementary data; license_evidence.json

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

YTS-1 bladder cancer cells, control vs doxycycline-induced C1GALT1
silencing, triplicate LC-MS/MS. Source does not establish biological
independence vs technical injection; replicate type explicitly unknown.
O-glycopeptide source rows (117 reported glycopeptides,67 proteins),
source ambiguous localization and sequence window preserved Complete
selected source rows and measurements retained without additional
numerical processing.

Source scale: author Intensity columns, positive linear; do not treat
zeros as absent rows or impute.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Available from the versioned `data-v0.2.0` GitHub data release.
Downloads are verified by file size and SHA-256 and cached for offline
reuse.
