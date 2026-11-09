# Plasma extracellular-vesicle N-glyco enrichment method comparison

Plasma extracellular-vesicle N-glyco enrichment method comparison

## Usage

``` r
glyhub_PXD013893_N_EVEnrichmentMethods(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 1527 source rows and 6 measurements.

## Source

<https://doi.org/10.1038/s41596-019-0260-5>. CC0 1.0 repository dataset

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

Complete 1527-row author native site-group table with six technical
measurements. Includes reverse and potential-contaminant rows; use
explicit row_role and source flags when selecting biological targets.
All original source columns, multiplicity alternatives, zeros and
ambiguous groups remain available. No new filtering, normalization or
imputation; these are not six independent patients.

Source scale: author native MaxQuant site-group intensity; not LFQ or
downstream imputed abundance.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Available from the versioned `data-v0.2.0` GitHub data release.
Downloads are verified by file size and SHA-256 and cached for offline
reuse.
