# Caenorhabditis elegans developmental O-glycan profiles

Complete Supplementary Table S2 of Increasing Complexity of the
N-Glycome During Caenorhabditis Development: 20 O-glycan features
quantified across six source culture profiles.

## Usage

``` r
glyhub_GPST000294_O_Celegans_Development(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 20 features and 6 observations. The abundance assay is in percent
occurrence. rowData has no glycan_structure column because no feature
has a supported structural annotation.

## Source

GlycoPOST GPST000294. . Study:
<https://doi.org/10.1016/j.mcpro.2023.100505>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000294>. Quantitative source:
<https://www.ebi.ac.uk/europepmc/webservices/rest/PMC7614267/supplementaryFiles>.

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

O-glycans were released by reductive beta-elimination from peptic
glycopeptides remaining after PNGase A/F digestion and analyzed without
further derivatization by LC-ESI-MS. Source PDF page 18 has calculated
m/z, RT, composition and paired observed-m/z/percentage columns for six
samples. Only percentage occurrence is quantitative abundance; observed
m/z, nd and fragmentation asterisks are annotations. All 20 rows are
retained, including same-composition isomers. Quantitative zeros become
NA without imputation or renormalization; raw zeros are preserved.
Source columns are culture profiles, not six biological replicates of a
common condition. Replication for individual S2 profiles is not explicit
and remains unknown. The separately distributed N-glycan Table S1 object
extracts the reported percentages from mixed retention-time/percentage
cells, preserving censored inequalities and unreported values
explicitly.

Explicit author composition tokens provide Hex, HexNAc, dHex, HexA and
PC/Me substituent counts. The source Hex3HexNAc1 Hex1Me has four Hex
residues and one Me substituent. No Fuc identity is assigned to generic
dHex. Linear/branched qualifiers and source isomers remain annotations;
no full structure is inferred.

## Access

Use `glyhub_load("glyhub_GPST000294_O_Celegans_Development")` to load
this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
