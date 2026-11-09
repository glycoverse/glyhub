# Deidentified HeartSurfaceome

Deidentified HeartSurfaceome

## Usage

``` r
glyhub_MSV000088624_N_HeartSurfaceome(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 490 source rows and 7 measurements.

## Source

<https://doi.org/10.1038/s44161-022-00200-y>. CC BY 4.0 original-author
supplementary measurements; no separate exclusion identified

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

Source scale: author log2 normalized protein surfaceome abundance;
upstream author imputation.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Available from the versioned `data-v0.2.0` GitHub data release.
Downloads are verified by file size and SHA-256 and cached for offline
reuse.
