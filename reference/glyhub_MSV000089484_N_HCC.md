# pGlycoQuant HCC cell-line source intensities

pGlycoQuant HCC cell-line source intensities

## Usage

``` r
glyhub_MSV000089484_N_HCC(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Source

<https://doi.org/10.1038/s41467-022-35172-x>.

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

## Value

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html).

## Details

11,001 source feature rows across 12 reported measurement columns.

Assay scale: Source SILAC glycoform-site intensity; -1 mapped to NA by
user-confirmed curation convention

Exactly 40338 source -1 entries mapped to assay NA by explicit user
instruction; the author has not directly defined this code in inspected
sources

Original -1 entries and every source value remain in metadata
raw_abundance

All 2137 zeros and every positive intensity preserved exactly; no log
transform, normalization, imputation or filtering

One record per source protein/site/glycan row; no invented peptide
sequence or PSM

The 6435-row filtered sheet is not a separate dataset or cohort

Repeat labels do not establish independent biological replication

Measurement columns are not automatically independent biological
samples. Source row identifiers, annotations and provenance are retained
in metadata.

The assay maps source -1 to NA by user-confirmed convention, not an
author-confirmed definition. All source values, including -1, remain in
metadata raw_abundance; zeros and positive values are unchanged.

## Availability and source license

Downloaded from the existing data release through the verified cache.
Source-license scope for the complete object remains unresolved; no new
license is granted. See publication-decisions.tsv and object metadata
for original sources and limitations.

## See also

[`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md),
[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
