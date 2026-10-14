# Red-blood-cell O-glycan precursor quantification

Complete public Panorama precursor-by-sample TotalArea export; all
source precursors including explicitly marked glucose QC/normalization
standards retained.

## Usage

``` r
glyhub_GPST000128_o_precursor
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 35 features and 6 observations. The abundance assay is in
peak_area. rowData has no glycan_structure column because no feature has
a supported structural annotation.

## Source

GlycoPOST GPST000128. Panorama PrecursorChromInfo. Study:
<https://doi.org/10.1182/bloodadvances.2020003376>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000128>. Quantitative source:
<https://panoramaweb.org/Panorama%20Public/2020/U%20of%20Nebraska%20Medical%20Center%20Gundry%20Lab%20-%20Sickle%20Cell%20Manuscript/query-selectRows.api?schemaName=targetedms&query.queryName=PrecursorChromInfo&query.maxRows=2000>.

## Details

Six source sample identifiers 07,08,13,39,55,56 retained. Clinical group
mapping not verified, group=NA. Multiple precursors per glycan remain
separate by source precursor ID; no arbitrary charge merging. This is an
already integrated processed quantity export, no raw-MS reprocessing.

Molecular annotations retain source precision. Unresolved compositions
or structures are NA; original annotations are retained in rowData. All
quantitative source features are preserved.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
