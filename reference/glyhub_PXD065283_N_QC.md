# HCC study quality-control injections

HCC study quality-control injections

## Usage

``` r
glyhub_PXD065283_N_QC(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Source

<https://doi.org/10.1002/advs.202516299>.

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

8,030 source feature rows across 30 reported measurement columns.

Assay scale: Source linear MBR-derived glycosite/glycan quantities;
upstream normalization not independently established

Source selection: Linear QC matrix chosen; clinical DE-selected log2
table is a separate cohort dataset.

All source cells preserved; no new normalization, imputation, filtering,
inverse transform or aggregation

Source reports match-between-run quantification; source blank values
retained as NA

30 QC injections (13 days, 3 repeated injections, 14 batch QC runs), not
30 independent people

No exponentiation to claim recovered original intensity; unspecified
upstream settings remain unknown

Measurement columns are not automatically independent biological
samples. Source row identifiers, annotations and provenance are retained
in metadata.

The assay preserves source numeric values. The metadata field
raw_abundance means source numbers; it does not certify that the authors
supplied unprocessed intensity.

## Availability and source license

Downloaded from the existing data release through the verified cache.
Source-license scope for the complete object remains unresolved; no new
license is granted. See publication-decisions.tsv and object metadata
for original sources and limitations.

## See also

[`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md),
[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
