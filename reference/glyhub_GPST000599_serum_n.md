# Septic shock longitudinal serum N-glycome

Complete published glycan-by-sample peak-area matrix, 45 source glycan
features and 134 samples; paired fractional abundance block preserved.

## Usage

``` r
glyhub_GPST000599_serum_n
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 45 features and 134 observations. The abundance assay is in
peak_area. rowData has no glycan_structure column because no feature has
a supported structural annotation.

## Source

GlycoPOST GPST000599. Table S2. Study:
<https://doi.org/10.1016/j.mcpro.2025.101470>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000599>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000599.0/Supplementary%20Table.xlsx>.

## Details

Complete 45-feature by 134-sample glycan peak areas exactly match
publisher SI Table S3. Relative abundance verified raw/column sum.
Patient-ICU day naming is explicit in publisher SI; all 134 samples
mapped without ambiguity to 37 subjects and actual sampling dates in S1.
Clinical missing values N/A/Unknown remain null. Other SI tables are
identification PSMs, narrow Lex subsets or peptide LFQ and are not
imported as glycan matrices.

Molecular annotations retain source precision. Unresolved compositions
or structures are NA; original annotations are retained in rowData. All
quantitative source features are preserved.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
