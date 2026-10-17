# Human organ atlas raw XIC matrix

Human organ atlas raw XIC matrix

## Usage

``` r
glyhub_PXD070547_N_HumanAtlas(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Source

<https://doi.org/10.1038/s41467-026-74631-7>.

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

57,884 source feature rows across 219 reported measurement columns.

Assay scale: Source Skyline extracted-ion chromatogram quantification;
raw relative signal

Explicit source NA strings and blanks -\> NA; no imputation,
normalization, filtering, zero conversion or aggregation

Annotation joined only by exact ID: unmatched source rows retained with
unknown molecular annotation

Source linkage notation retained, no unverified structure parser or
inferred linkage

S monosaccharide is unspecified sialic acid; sialylated typed
compositions remain NA

Source age/sex cells are cohort summaries, not person-level values; not
propagated to samples

Use original measured columns, not the normalized or KNN/ComBat matrices

Measurement columns are not automatically independent biological
samples. Source row identifiers, annotations and provenance are retained
in metadata.

The assay preserves source numeric values. The metadata field
raw_abundance means source numbers; it does not certify that the authors
supplied unprocessed intensity.

## Local availability

Locally staged only; the complete object's redistribution permission is
unresolved. Build with `data-raw/noncptac/build.R` and use the supplied
local cache. No remote URL is provided. See publication-decisions.tsv
for the source-specific reason.

## See also

[`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md),
[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
