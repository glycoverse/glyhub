# Serum N-glycan profiles across hepatocellular carcinoma progression

MALDI-TOF serum N-glycomics from the hepatocellular carcinoma study,
retaining the complete published pre-processing abundance table.

## Usage

``` r
glyhub_GPST000584_N(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 201 features and 743 observations. The abundance assay is in peak
area. rowData has no glycan_structure column because no feature has a
supported structural annotation.

## Source

GlycoPOST GPST000584. raw. Study:
<https://doi.org/10.1038/s41467-026-68579-x>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000584>.

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

The raw sheet of Supplementary Data 2 contains 201 composition features
and 743 source observations. The separate processed sheet is a filtered,
normalized subset and is not appended as independent samples. Published
clinical fields from Supplementary Data 8 are joined by exact sample ID;
unmatched samples retain missing clinical metadata. The assay contains
original peak-area measurements, with source zeros represented as
missing and no new imputation or normalization. Composition-level
measurements do not establish glycan topology or linkage isomers.
Disease groups are joined from explicit sample/group columns in the
source-data workbook, without inferring groups from sample numbering.

Source molecular compositions retained without inferring glycosidic
linkages.

## Access

Use `glyhub_load("glyhub_GPST000584_N")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
