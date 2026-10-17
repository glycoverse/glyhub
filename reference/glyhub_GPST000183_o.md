# MLL-rearranged B-cell precursor ALL O-glycome

Complete source abundance matrix; O-table merged glycan identity spans
alternative charge rows, with quantities taken from the sole nonempty
quantitative row.

## Usage

``` r
glyhub_GPST000183_o(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 21 features and 20 observations. The abundance assay is in
relative_abundance_percent. rowData has no glycan_structure column
because no feature has a supported structural annotation.

## Source

GlycoPOST GPST000183. Glycomics Reporting. Study:
<https://doi.org/10.7150/thno.65398>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000183>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000183.0/Sup%20Table%204%20-%20O-glycomics%20Results.xlsx>.

## Arguments

- kind:

  `"curated"` returns a data object; `"raw"` returns the path to a
  verified source archive. Raw archives are currently available for
  CPTAC.

- cache_dir:

  Cache directory, defaulting to `tools::R_user_dir("glyhub", "cache")`.
  Set option `glyhub.cache_dir` to change the default.

- refresh:

  Download the pinned resource again, even if cached.

- offline:

  Prohibit downloads; require a verified local resource.

## Details

All published features and samples retained, including N-table
BM41/R7B11 that paper later excluded from final preparations due to low
yield; flag rather than silently discard. GlyTouCan IDs retained as
identifiers, not invented full structures. N table is seven per-donor
relative abundance profiles; O suffixes 1-4 are technical replicates per
paper figure caption.

Molecular annotations retain source precision. Unresolved compositions
or structures are NA; original annotations are retained in rowData. All
quantitative source features are preserved.

## Access

Use `glyhub_load("glyhub_GPST000183_o")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
