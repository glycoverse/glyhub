# N-glycan profiles in HEK293 glycosylation-knockout cells

Complete Table S4_1 N-glycan relative-abundance block from Global
mapping of glycosylation pathways in human-derived cells, comparing
wild-type HEK293 with seven glycosylation knockout conditions.

## Usage

``` r
glyhub_GPST000125_N_HEK293(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 41 features and 16 observations. The abundance assay is in percent
relative abundance. rowData includes a typed glycan_structure column;
features without a supported structure are NA.

## Source

GlycoPOST GPST000125. Table S4_1, N block. Study:
<https://doi.org/10.1016/j.devcel.2021.02.023>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000125>. Quantitative source:
<https://pmc.ncbi.nlm.nih.gov/articles/instance/8086148/bin/NIHMS1683936-supplement-5.xlsx>.

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

All source-numbered features and both experiment columns for all eight
conditions are retained. The article methods explicitly call these two
biological replicates. Average/error columns are retained only in source
cell records and are not sample observations. Quantitative zeros become
NA without renormalization; original numeric measurements remain in
raw_matrix. Same-composition source rows are not collapsed. Five
conflicting source compositions are supported by the original name and
diagram; one unresolved row remains NA. All conflicting registry IDs and
quantitative rows are preserved.

Composition counts are from source Component IDs resolved through the
official GlyTouCan WURCS registry. Generic base-composition residues are
counted directly from explicit WURCS residue indices; full structures
are parsed with glyparse 0.8.1 and glyrepr 1.1.0. A single,
non-conflicting source Structure ID is eligible for typed structure.
Candidate lists remain lists; no representative is chosen from a
mixture. Five previously conflicting compositions are supported by
original names and native-vector diagrams; N feature 17 remains
unresolved because its source drawing also disagrees. Registry
identifiers and all conflicting evidence remain intact. No mass-derived
structure or sample identity is inferred.

## Access

Use `glyhub_load("glyhub_GPST000125_N_HEK293")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
