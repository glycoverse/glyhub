# Oral tumor N-glycans associated with lymph node metastasis

Relative abundances of 83 isomer-resolved N-glycan features from 31 oral
squamous cell carcinoma tumors with or without lymph node metastasis.

## Usage

``` r
glyhub_GPST000296_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 83 features and 31 observations. The abundance assay is in relative
abundance fraction. rowData includes a typed glycan_structure column;
features without a supported structure are NA.

## Source

GlycoPOST GPST000296. Deposited Glycan_results.xlsx, TS3; published
supplementary spectral atlas. Study:
<https://doi.org/10.1016/j.mcpro.2023.100586>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000296>.

## Details

The complete source matrix contains 12 N0 and 19 N+ tumor samples.
Glycan isomers remain distinct and source MS/MS confirmation, retention
time, core fucosylation, bisecting GlcNAc and sialic-acid diagnostics
are retained. Eighty-two partial structures combine the source spectral
atlas with explicit sialic-acid linkage information from Table S3;
unnumbered linkages and unresolved arms remain unknown. Feature 9b has
no MS/MS-confirmed topology and retains composition only. Analytes were
reduced glycans; this preparation is recorded separately from
monosaccharide identity.

Source spectral-atlas topologies with TS3-supported sialic linkages;
unnumbered linkages and uncertain arms retained as unknown.
Composition-only annotation for 9b.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
