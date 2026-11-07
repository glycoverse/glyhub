# HGF time-course glycopeptide reporter intensities in two cell lines

HGF time-course glycopeptide reporter intensities in two cell lines

## Usage

``` r
glyhub_PXD017033_N_HGFTimecourse(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 2318 union feature rows and 12 measurements.

## Source

<https://doi.org/10.7150/thno.56882>. CC BY 4.0 author supplementary
quantitative data; attribution required

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

Complete SMMC-7721 and HepG2 TMT reporter experiments joined only on all
ten exact author feature annotations. Cell-line and batch are explicit;
six timepoints per cell line are six measured pools, each from three
biological replicates. Structural NA denotes features absent from one
source table; author zeros and missingness are independently retained.
Original experiments, PSM counts, alternative processed columns and
exact row/column maps remain available in metadata. Seven source
annotation conflicts retain both source labels and unknown canonical
composition; no topology is inferred. No interplex normalization,
imputation, filtering or additional value transformation.

Source scale: Author reporter-ion intensity columns, distinct from
provided normalized abundance and baseline-ratio columns; PSM column is
annotation only.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Locally staged for review; requires the maintainer's hash-verified
cache. No public data-release URL has been assigned.
