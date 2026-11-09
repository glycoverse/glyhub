# GproDIA source N-glycopeptide panel FissionYeast_DDA1h

GproDIA source N-glycopeptide panel FissionYeast_DDA1h

## Usage

``` r
glyhub_PXD023980_N_FissionYeast_DDA1h(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 666 source rows and 4 measurements.

## Source

<https://doi.org/10.1038/s41467-021-26246-3>. CC BY4.0 author
supplement; does not claim iProX independent deposit license

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

Technical repeat injections, NOT biological independent subjects. Same
underlying sample measured by DDA/DIA variants; objects must not be
counted as independent biological cohorts. Main default SSL result
chosen; same-run LRL/EXL reanalyses retained in original-source workbook
assets not claimed independent datasets. Site-Glycans/Glycosites are
same-measurement author aggregate views, not independent cohorts.
Complete selected author precursor matrix retained; no newly aligned or
aggregated features. Source peptide, composition, charge and ambiguous
protein/site annotations are preserved.

Source scale: author-provided linear DDA precursor abundance;
normalization status not established for this table.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Available from the versioned `data-v0.2.0` GitHub data release.
Downloads are verified by file size and SHA-256 and cached for offline
reuse.
