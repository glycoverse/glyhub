# O-glycan profiles in CAL51 Golgi knockout cells

Complete O-glycan relative-abundance profiles from CAL51 control, GOLGA5
knockout and GOLGA8M knockout cells, investigating organelle-biogenesis
interactions.

## Usage

``` r
glyhub_GPST000271_O_CAL51
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 7 features and 15 observations. The abundance assay is in percent
relative abundance. rowData has no glycan_structure column because no
feature has a supported structural annotation.

## Source

GlycoPOST GPST000271. Summary - O_glycans. Study:
<https://doi.org/10.1038/s41556-023-01297-4>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000271>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000271.1/Glycan_supplementary_table_N_O_glycan.xlsx>.

## Details

Five source-numbered observations are provided for each of the three
cell conditions. The source table does not explicitly establish
biological versus technical replicate status. Chromatographic features
with equal compositions remain separate; no cross-isomer collapse is
performed. Source mass and monosaccharide-count annotations remain
available. No glycan topology is inferred from composition.

Composition and retention-time-resolved feature labels are preserved;
structure is not assigned.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
