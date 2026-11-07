# Human cell-line N-glyco-enriched protein abundance

Human cell-line N-glyco-enriched protein abundance

## Usage

``` r
glyhub_PXD013627_N_HumanCellLines(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 892 source rows and 33 measurements.

## Source

<https://doi.org/10.1038/s41467-019-13418-5>. CC BY 4.0; original-author
supplementary abundance table, no separate exclusion located

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

11 cell lines x3 biological replicate, technical runs consolidated
N-glyco-enriched protein groups from deamidated sequon peptides, not
intact glycopeptides. No glycan compositions or quantitative protein
sites are available. The author-normalized log2 abundance remains log2;
it is not raw MS intensity.

Source scale: log2 author-normalized MSstats protein abundance; keep
original log2.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Locally staged for review; requires the maintainer's hash-verified
cache. No public data-release URL has been assigned.
