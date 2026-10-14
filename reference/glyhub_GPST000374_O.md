# SSSMuG: Same Sample Sequential Multi-Glycomics. and related study experiments

Sequential release versus single-class control from mouse brain lysate.
Author structural assignments retained with uncertainty; no inferred
cross-class subject pairing. O subclasses are separately normalized in
source and therefore separate objects. Combined O-glycan quantitative
profiles from GPST000374. 15 union features and 7 source observations
are represented.

## Usage

``` r
glyhub_GPST000374_O
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 15 features and 7 observations. The abundance assay is in LC-MS
peak area. rowData includes a typed glycan_structure column; features
without a supported structure are NA.

## Source

GlycoPOST GPST000374. Table S3 - O-glycans. Study:
<https://doi.org/10.1021/acs.analchem.3c04928>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000374>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000374.0/Glycopost%20result%20file.xlsx>.

## Details

Source experiments are identified in colData and original panel-specific
metadata, annotations and measurements are retained in metadata. Feature
identities are aligned only when supported by author identifiers or
explicit molecular structures; other features retain source-specific
identities. The source_coverage matrix distinguishes unmeasured
combinations from measured missing values. Units: LC-MS peak area.

SSSMuG: Same Sample Sequential Multi-Glycomics.: Sequential release
versus single-class control from mouse brain lysate. Author structural
assignments retained with uncertainty; no inferred cross-class subject
pairing. O subclasses are separately normalized in source and therefore
separate objects.

SSSMuG: Same Sample Sequential Multi-Glycomics.: Sequential release
versus single-class control from mouse brain lysate. Author structural
assignments retained with uncertainty; no inferred cross-class subject
pairing. O subclasses are separately normalized in source and therefore
separate objects.

SSSMuG: Same Sample Sequential Multi-Glycomics.: Sequential release
versus single-class control from mouse brain lysate. Author structural
assignments retained with uncertainty; no inferred cross-class subject
pairing. O subclasses are separately normalized in source and therefore
separate objects.

Molecular annotations retain source precision. Unresolved compositions
or structures are NA; original annotations are retained in rowData. All
quantitative source features are preserved.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
