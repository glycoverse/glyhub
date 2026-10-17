# Cardiac N-glycomes in fatal COVID-19

N-glycan MS1 peak areas from cardiac tissue and isolated cardiomyocytes
of COVID-positive and COVID-negative donors.

## Usage

``` r
glyhub_GPST000460_N(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 162 features and 43 observations. The abundance assay is in peak
area. rowData includes a typed glycan_structure column; features without
a supported structure are NA.

## Source

GlycoPOST GPST000460. Tables S5-S8. Study:
<https://doi.org/10.1021/acs.analchem.3c03649>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000460>.

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

Four source tables are combined by exact composition-plus-retention
labels, normalizing only GU/RRT notation and spacing. The sample
metadata distinguishes FFPE tissue from isolated cardiomyocytes and
COVID status. Features absent from a source table remain missing rather
than zero. Maltodextrin calibration ladders and class summaries are
excluded. Published GlyTouCan structures are linked only when
composition and retention position identify a unique annotation;
inconsistent registry assignments remain unresolved. Clinical metadata
uses exact published patient identifiers; abbreviated ambiguous
cardiomyocyte IDs are not guessed.

Author glycan labels, additive monosaccharide counts, and uniquely
matched registry structures. Source/registry annotation conflicts are
preserved for review.

## Access

Use `glyhub_load("glyhub_GPST000460_N")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
