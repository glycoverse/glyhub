# Colorectal-cancer cell-line glycosphingolipid glycans

Relative glycosphingolipid-glycan abundances across 22 human
colorectal-cancer cell lines spanning unassigned, undifferentiated and
colon-like transcriptional subtypes.

## Usage

``` r
glyhub_GPST000239_GSL
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 94 features and 22 observations. The abundance assay is in relative
abundance (%). rowData includes a typed glycan_structure column;
features without a supported structure are NA.

## Source

GlycoPOST GPST000239. S-5. Study:
<https://doi.org/10.1016/j.mcpro.2022.100239>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000239>.

## Details

Supplementary Table S5 supplies 94 chromatographically distinguished
glycan features and cell-line aggregate abundance values. Cell-line
origin, tumour stage, differentiation and microsatellite status are
joined from Table S1 when the source identifier matches exactly.
Original antigen, glycan-family and linkage annotations are retained.
Typed structures are transcribed from the same-row SNFG diagrams with
all unspecified linkages left unknown; repeated compositions remain
separate isomer features. Values are cell-line summaries, not individual
biological-replicate measurements.

Source-derived compositions and original labels are retained. 94
source-supported structures are typed; unspecified bonds remain unknown.
Unresolved or conflicting structures remain missing with source
provenance.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
