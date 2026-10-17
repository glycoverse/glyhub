# Fetuin N-glycan peak areas across two instrument sites

Complete 14-feature two-site fetuin source peak-area block. Site 1 and
Site 2 remain distinct observations. Their sample identity/pairing is
not inferred; accompanying dotp values are retained as quality
annotations, not quantitative abundance.

## Usage

``` r
glyhub_GPST000578_N_Fetuin_TwoSites(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 14 features and 2 observations. The abundance assay is in peak
area. rowData includes a typed glycan_structure column; features without
a supported structure are NA.

## Source

GlycoPOST GPST000578. Figure 4e. Study:
<https://doi.org/10.1038/s41467-026-73091-3>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000578>. Quantitative source:
<https://media.springernature.com/original/springer-static/esm/art%3A10.1038%2Fs41467-026-73091-3/MediaObjects/41467_2026_73091_MOESM4_ESM.xls>.

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

Complete 14-feature two-site fetuin source peak-area block. Site 1 and
Site 2 remain distinct observations. Their sample identity/pairing is
not inferred; accompanying dotp values are retained as quality
annotations, not quantitative abundance. Quantitative zeros are
represented as NA without imputation or renormalization; original
measurements are retained. GlyTouCan identifiers remain the source
assignments. Sites refer to laboratories/instruments, not protein
glycosylation sites. Figure 4c names Site A (Altis Plus) and Site B
(Altis); the workbook labels Site 1 and Site 2 are retained without
inferring additional correspondence.

All source GlyTouCan identifiers resolve to WURCS through the official
GlyTouCan SPARQL service. Structures are converted with glyparse 0.8.1
and validated with glyrepr 1.1.0, and compositions are derived from the
validated structures. No mass-based assignments or new experimental
linkage evidence are inferred.

## Access

Use `glyhub_load("glyhub_GPST000578_N_Fetuin_TwoSites")` to load this
dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
