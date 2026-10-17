# Released N-glycans of pSAP65 and pSAP75 prosaposin forms

Relative N-glycan profiles of two prosaposin forms in a study of
hyperglycosylation and tumor dendritic-cell immune escape. The
author-aligned expression table contains 36 features and two profile
observations.

## Usage

``` r
glyhub_GPST000381_N_Prosaposin(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 36 features and 2 observations. The abundance assay is in fraction
of the source profile total intensity. rowData has no glycan_structure
column because no feature has a supported structural annotation.

## Source

GlycoPOST GPST000381. Sheet1. Study:
<https://doi.org/10.1126/science.adg1955>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000381>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000381.0/Analyzed%20data.xlsx>.

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

The quantitative assay is the complete Relative expression block (I:J),
using its pSAP65 and pSAP75 column labels. The separate intensity blocks
B and E carry contradictory pSAP labels: their relative values match
expression columns J and I, respectively. The expression-block labels
are adopted for this dataset; this is a curation choice, not an
author-issued correction. The complete workbook and original labels
remain available. Source expression values are fractions that sum to one
per observed profile; they are not multiplied by 100. Blank cells remain
missing. The source does not identify biological or technical
replication for these two profiles, so replicate type is unknown.

Composition counts are directly transcribed from the author Sugar
Composition block; NeuAc and NeuGc are distinguished. No glycan
structure is inferred from composition or mass.

## Access

Use `glyhub_load("glyhub_GPST000381_N_Prosaposin")` to load this
dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
