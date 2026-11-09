# Deidentified SerumDiseaseGroups

Deidentified SerumDiseaseGroups

## Usage

``` r
glyhub_PMC10983713_N_SerumDiseaseGroups(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 1114 source rows and 80 measurements.

## Source

<https://doi.org/10.1186/s12964-024-01569-y>. CC BY 4.0 author
supplementary quantitative data; attribution required

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

Source scale: Author linear per-sample glycopeptide abundances, separate
\#PSMs annotation excluded as assay. All source0 preserved; no
normalization or imputation added. Quantification implementation not
fully specified in current methods; label as author abundance, not
asserted raw detector signal..

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Available from the versioned `data-v0.2.0` GitHub data release.
Downloads are verified by file size and SHA-256 and cached for offline
reuse.
