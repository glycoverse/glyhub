# Serum N-glycan profiles across hepatocellular carcinoma progression

MALDI-TOF serum N-glycomics from the hepatocellular carcinoma study,
retaining the complete published pre-processing abundance table.

## Usage

``` r
glyhub_GPST000584_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 201 features and 743 observations. The abundance assay is in peak
area. rowData has no glycan_structure column because no feature has a
supported structural annotation.

## Source

GlycoPOST GPST000584. raw. Study:
<https://doi.org/10.1038/s41467-026-68579-x>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000584>.

## Details

The raw sheet of Supplementary Data 2 contains 201 composition features
and 743 source observations. The separate processed sheet is a filtered,
normalized subset and is not appended as independent samples. Published
clinical fields from Supplementary Data 8 are joined by exact sample ID;
unmatched samples retain missing clinical metadata. The assay contains
original peak-area measurements, with source zeros represented as
missing and no new imputation or normalization. Composition-level
measurements do not establish glycan topology or linkage isomers.
Disease groups are joined from explicit sample/group columns in the
source-data workbook, without inferring groups from sample numbering.

Source molecular compositions retained without inferring glycosidic
linkages.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
