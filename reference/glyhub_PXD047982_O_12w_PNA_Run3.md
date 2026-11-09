# Mouse testis source PSM MonoArea 12w PNA 3

Mouse testis source PSM MonoArea 12w PNA 3

## Usage

``` r
glyhub_PXD047982_O_12w_PNA_Run3(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 557 source rows and 1 measurements.

## Source

<https://doi.org/10.1038/s41467-025-57980-7>. CC0-1.0 under iProX
dataset policy and verified submission date

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

One author run-specific PSM table. Each column is one actual run, not a
quantitative metric. Repeated molecular features remain separate source
PSM rows, identified by GlySpec/Scan and source row. These objects are
not aligned across runs; no merging, summing or filling is performed.
IsotopeArea and corrected-area sentinels remain source annotations.
Source plausible structures and composition labels are preserved without
unverified typed conversion.

Source scale: linear author MonoArea per source PSM; not aligned across
runs.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Available from the versioned `data-v0.2.0` GitHub data release.
Downloads are verified by file size and SHA-256 and cached for offline
reuse.
