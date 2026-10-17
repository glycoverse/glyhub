# Bladder-tissue N-glycans across cancer stages

N-glycan profiles from healthy bladder, cystitis and Ta, T1 and
muscle-invasive bladder tumours. The table contains five observations in
each of the first four groups and eight in the muscle-invasive group.

## Usage

``` r
glyhub_GPST000585_N(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 23 features and 28 observations. The abundance assay is in
source-labelled relative abundance (%). rowData has no glycan_structure
column because no feature has a supported structural annotation.

## Source

GlycoPOST GPST000585. Table S1. Study:
<https://doi.org/10.3390/ijms26104891>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000585>.

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

PNGase F-released, reduced and permethylated N-glycans were quantified
by mass spectrometry. Source Table S1 relative-abundance values are
preserved without rescaling; paired peak areas are retained in row
annotations rather than duplicating the dataset. n.d. cells are missing.
Composition identities and source glycan classes are preserved without
converting class labels into asserted structures.

Source-derived composition annotations; linkage information is retained
as source annotation without inferring a full topology. No complete
unambiguous structures are asserted.

## Access

Use `glyhub_load("glyhub_GPST000585_N")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
