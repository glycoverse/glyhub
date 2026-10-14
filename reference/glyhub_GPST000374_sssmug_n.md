# SSSMuG: Same Sample Sequential Multi-Glycomics.

Sequential release versus single-class control from mouse brain lysate.
Author structural assignments retained with uncertainty; no inferred
cross-class subject pairing. O subclasses are separately normalized in
source and therefore separate objects.

## Usage

``` r
glyhub_GPST000374_sssmug_n
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 218 features and 10 observations. The abundance assay is in LC-MS
peak area. rowData includes a typed glycan_structure column; features
without a supported structure are NA.

## Source

GlycoPOST GPST000374. Table S2 - N-glycans. Study:
<https://doi.org/10.1021/acs.analchem.3c04928>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000374>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000374.0/Glycopost%20result%20file.xlsx>.

## Details

Sequential release versus single-class control from mouse brain lysate.
Author structural assignments retained with uncertainty; no inferred
cross-class subject pairing. O subclasses are separately normalized in
source and therefore separate objects.

Molecular annotations retain source precision. Unresolved compositions
or structures are NA; original annotations are retained in rowData. All
quantitative source features are preserved.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
