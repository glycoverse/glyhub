# Rat serum N-glycopeptides across repeated sampling

Glycopeptide-level grouped abundances from albumin/IgG-depleted rat
serum, sampled on five days in three female rats and one male rat.

## Usage

``` r
glyhub_GPST000601_N_glycopeptides
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 1256 features and 20 observations. The abundance assay is in source
grouped abundance (relative scale). rowData has no glycan_structure
column because no feature has a supported structural annotation.

## Source

GlycoPOST GPST000601. Table S2. Study:
<https://doi.org/10.3390/ijms26157266>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000601>.

## Details

Supplementary Table S2 provides 1256 quantified peptide-glycan feature
rows. Grouped abundance columns are preserved on the published scale.
Individual acquisition columns have mixed normalization labels and are
retained only in the source workbook. Glycan acetyl counts are
represented explicitly. A single protein site is assigned only when one
protein position and one localized N-glycosylation site are unambiguous;
all original peptide and protein mappings are retained.

Source-derived compositions and original annotation fields are
preserved; unknown linkages are not inferred.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
