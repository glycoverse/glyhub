# Swift Universal Glycan Acquisition (SUGA) Enables Quantitative Glycan Profiling across Diverse Sample Types. and related study experiments

Native unreduced released N-glycan composition quantification. Drug
treatment/time is column metadata; includes three identified blanks.
Combined N-glycan quantitative profiles from GPST000431. 70 union
features and 62 source observations are represented.

## Usage

``` r
glyhub_GPST000431_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 70 features and 62 observations. The abundance assay is in MS1
integrated area. rowData has no glycan_structure column because no
feature has a supported structural annotation.

## Source

GlycoPOST GPST000431. SUGA_DrugTreatments_GlycanQuant. Study:
<https://doi.org/10.1021/acs.jproteome.4c00657>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000431>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000431.1/SUGA_DrugTreatments_GlycanQuant_treatmentkey.xlsx>.

## Details

Source experiments are identified in colData and original panel-specific
metadata, annotations and measurements are retained in metadata. Feature
identities are aligned only when supported by author identifiers or
explicit molecular structures; other features retain source-specific
identities. The source_coverage matrix distinguishes unmeasured
combinations from measured missing values. Units: MS1 integrated area.

Swift Universal Glycan Acquisition (SUGA) Enables Quantitative Glycan
Profiling across Diverse Sample Types.: Native unreduced released
N-glycan composition quantification. Drug treatment/time is column
metadata; includes three identified blanks.

Swift Universal Glycan Acquisition (SUGA) Enables Quantitative Glycan
Profiling across Diverse Sample Types.: Native unreduced released
N-glycan composition quantification. Independent method benchmark;
distinct experiments are retained in column metadata.

Swift Universal Glycan Acquisition (SUGA) Enables Quantitative Glycan
Profiling across Diverse Sample Types.: Native unreduced released
N-glycan composition quantification. Independent method benchmark;
distinct experiments are retained in column metadata.

Molecular annotations retain source precision. Unresolved compositions
or structures are NA; original annotations are retained in rowData. All
quantitative source features are preserved.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
