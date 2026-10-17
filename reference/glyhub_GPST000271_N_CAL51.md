# N-glycan profiles in CAL51 Golgi knockout cells

Complete N-glycan relative-abundance profiles from CAL51 control, GOLGA5
knockout and GOLGA8M knockout cells, investigating organelle-biogenesis
interactions.

## Usage

``` r
glyhub_GPST000271_N_CAL51(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 69 features and 15 observations. The abundance assay is in percent
relative abundance. rowData has no glycan_structure column because no
feature has a supported structural annotation.

## Source

GlycoPOST GPST000271. Summary - N_glycans. Study:
<https://doi.org/10.1038/s41556-023-01297-4>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000271>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000271.1/Glycan_supplementary_table_N_O_glycan.xlsx>.

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

Five source-numbered observations are provided for each of the three
cell conditions. The source table does not explicitly establish
biological versus technical replicate status. Chromatographic features
with equal compositions remain separate; no cross-isomer collapse is
performed. Source mass and monosaccharide-count annotations remain
available. No glycan topology is inferred from composition.

Composition and retention-time-resolved feature labels are preserved;
structure is not assigned.

## Access

Use `glyhub_load("glyhub_GPST000271_N_CAL51")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
