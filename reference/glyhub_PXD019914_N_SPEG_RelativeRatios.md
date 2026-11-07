# Deidentified SPEG_RelativeRatios

Deidentified SPEG_RelativeRatios

## Usage

``` r
glyhub_PXD019914_N_SPEG_RelativeRatios(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 5115 source rows and 129 measurements.

## Source

<https://doi.org/10.1038/s41467-020-19976-3>. CC BY 4.0 original-author
supplementary measurements

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

Deidentified human-source derivative with unchanged selected
quantitative values; original patient identifiers and individual
clinical covariates are omitted. Necessary groups, QC and repeat-subject
design are retained using study-local anonymous labels.

Source scale: linear relative ratio (2^author-normalized log2 ratio),
not raw intensity.

Assay values are 2^x of author-normalized log2 ratios: linear relative
ratios, not raw intensity. The original log2 matrix is retained in
`metadata(x)$raw_abundance`; source zero becomes one. Missing values
remain missing. No further normalization or imputation is applied. No
glycan structures are inferred. Consult metadata for provenance, source
row/column coordinates, attribution and limitations.

## Availability

Locally staged for review; requires the maintainer's hash-verified
cache. No public data-release URL has been assigned.
