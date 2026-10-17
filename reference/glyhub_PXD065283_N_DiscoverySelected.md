# HCC discovery cohort selected processed features

HCC discovery cohort selected processed features

## Usage

``` r
glyhub_PXD065283_N_DiscoverySelected(
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

1,038 source feature rows across 140 reported measurement columns.

Assay scale: Source median-normalized, log2-transformed, normally
imputed abundance; DE-selected features

Source selection: Only verified public individual clinical matrix;
earliest unnormalized clinical table unavailable through inspected
sources. QC linear table is a different experiment, not a substitute for
clinical samples.

All source cells preserved; no new normalization, imputation, filtering,
inverse transform or aggregation

Source workflow: MBR, source missingness filtering, median
normalization, log2, normal-distribution interpolation, then
differential-feature selection (p\<=0.01 and absolute log2FC\>=1)

1038 selected features and 140 discovery samples; not the full
8902-feature matrix or 60-person validation cohort. Feature selection
uses case labels; unsuitable for unbiased discovery or classifier
performance estimates.

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
