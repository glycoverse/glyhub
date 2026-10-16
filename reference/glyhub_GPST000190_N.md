# Linkage-specific sialic-acid derivatization of plasma N-glycans

Background-subtracted extracted-ion intensities of procainamide-labelled
plasma N-glycans after linkage-specific sialic-acid derivatization.

## Usage

``` r
glyhub_GPST000190_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 78 features and 54 observations. The abundance assay is in
background-subtracted extracted-ion intensity. rowData has no
glycan_structure column because no feature has a supported structural
annotation.

## Source

GlycoPOST GPST000190. Table S-3. Study:
<https://doi.org/10.1021/acs.analchem.1c02610>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000190>.

## Details

The deposited complete extraction table contains 39
composition/retention features in two charge states across 54 LC-MS
runs, including explicitly labelled blanks. Charge states remain
separate measurement features rather than being summed without an
author-defined rule. Am and E denote the source derivatization products
used to distinguish alpha2,3- and alpha2,6-linked sialic acids; their
counts are retained alongside the underlying Neu5Ac composition.
Unmeasured charge states and reported zeros are missing in the curated
assay. Run identifiers retain the original experimental batches; they
are not interpreted as independent biological donors.

Composition-level glycans with source charge, retention time,
procainamide label, and linkage-specific sialic-acid derivative counts;
no full topology inferred.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
