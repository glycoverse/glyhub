# Cornu aspersum mucus O-glycan profiles

Released glycans from adhesive, lubricating and protective snail mucus,
measured by glycomic mass spectrometry after per-deuter-O-methylation.

## Usage

``` r
glyhub_GPST000297_O(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 13 features and 3 observations. The abundance assay is in relative
glycan peak-area percentage. rowData includes a typed glycan_structure
column; features without a supported structure are NA.

## Source

GlycoPOST GPST000297. Supplementary Table 9 (PDF S46). Study:
<https://doi.org/10.1038/s41467-023-41094-z>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000297>.

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

All 14 reported rows of Supplementary Table 9 are retained across three
source mucus profiles. Values are the published glycan-peak area
percentages. Identical source mass/composition/topology assignments are
aligned across samples; conflicting masses or proposed isomers remain
distinct. Unreported combinations are missing and no renormalization is
applied. O-glycan lubricating and protective reported totals are 25.16%
and 99%, respectively, retained as published. Native methyl substituents
are preserved separately from analytical derivatization.

All 13 proposed O-glycan structures are encoded with unknown linkages
and source floating-group ambiguity. Native methyl substituents remain
explicit.

## Access

Use `glyhub_load("glyhub_GPST000297_O")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
