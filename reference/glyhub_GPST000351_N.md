# Plasma N-glycomes of ASGR1- and MRC1-deficient mice under dietary challenge

Seventy-two sialic-linkage-resolved plasma N-glycan features across 46
MALDI-TOF-MS observations from a study of hepatic and macrophage
glycan-receptor deficiency. Observations include experimental animals
and pooled controls.

## Usage

``` r
glyhub_GPST000351_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 72 features and 46 observations. The abundance assay is in relative
abundance fraction. rowData has no glycan_structure column because no
feature has a supported structural annotation.

## Source

GlycoPOST GPST000351. . Study:
<https://doi.org/10.1016/j.mcpro.2023.100615>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000351>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000351.0/TPNG%20curated%20data%20MALDI.xlsx>.

## Details

The complete author-renormalized matrix is retained as fractions, with
its individual acquisition filenames as observation identifiers.
Genotype, diet, sex, sample ID and source group are joined by exact
acquisition filename. Pooled controls remain explicitly identified; the
source metadata are not reinterpreted as independent animals.
Neu5Ac/Neu5Gc linkage-specific derivatization and O-acetylated species
are preserved. No additional normalization or imputation is performed.

H and N encode Hex and HexNAc; F encodes Fuc. Ge/Gl encode
alpha2,6/alpha2,3-linked Neu5Gc, E/L encode the corresponding Neu5Ac
linkages, and Ac denotes an acetyl substituent. Linkage counts remain in
source annotations; composition does not imply a full structure.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
