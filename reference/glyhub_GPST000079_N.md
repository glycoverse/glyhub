# Postnatal mouse skeletal-muscle N-glycome

Released N-glycans from skeletal muscle at postnatal days 1, 7, 14 and
21, with three source observations at each age.

## Usage

``` r
glyhub_GPST000079_N(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 104 features and 12 observations. The abundance assay is in
relative abundance (fraction). rowData has no glycan_structure column
because no feature has a supported structural annotation.

## Source

GlycoPOST GPST000079. BP_muscles_rawdata_251017_Perse. Study:
<https://doi.org/10.1074/mcp.ra120.002166>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000079>.

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

Supplementary Table S5 individual abundance columns are used; derived
fold changes, SEMs and group averages are not treated as additional
samples. The source isomer identifiers and partial linkage annotations
are retained. This matrix supports the study of the
digalactose-to-sialic-acid switch during muscle development.

Source-derived compositions and original annotation fields are
preserved; unknown linkages are not inferred.

## Access

Use `glyhub_load("glyhub_GPST000079_N")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
