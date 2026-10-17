# Rat serum N-glycans after chronic herbicide exposure

Serum N-glycan profiles from control and
glyphosate-based-herbicide-exposed rats, comprising six control males,
six control females, five exposed males and seven exposed females.

## Usage

``` r
glyhub_GPST000403_N(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 113 features and 24 observations. The abundance assay is in
relative abundance (%). rowData has no glycan_structure column because
no feature has a supported structural annotation.

## Source

GlycoPOST GPST000403. Sheet1. Study:
<https://doi.org/10.3390/biom14091077>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000403>.

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

The 113-feature matrix is the final percentage matrix on Sheet 1,
corroborated by published Supplementary Tables S1 and S2. Sheet 2
contains a differently normalised intermediate for the same samples and
is not duplicated as independent observations. Five-digit glycan codes
follow the paper order HexNAc, Hex, Fuc, NeuAc and NeuGc. Compositions
are retained; structural isomers are unresolved.

Source-derived composition annotations; linkage information is retained
as source annotation without inferring a full topology. No complete
unambiguous structures are asserted.

## Access

Use `glyhub_load("glyhub_GPST000403_N")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
