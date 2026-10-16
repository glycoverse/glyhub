# Longitudinal rat-serum released N-glycans

Released serum N-glycan amounts from four female and four male rats
sampled over five days, measured in 139 explicitly named technical MALDI
acquisitions.

## Usage

``` r
glyhub_GPST000601_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 14 features and 139 observations. The abundance assay is in pmol
(source export). rowData includes a typed glycan_structure column;
features without a supported structure are NA.

## Source

GlycoPOST GPST000601. quantitative-only (combine). Study:
<https://doi.org/10.3390/ijms26157266>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000601>.

## Details

The complete quantitative-only (combine) export contains 14 features and
139 acquisition columns; repeated acquisitions are technical
observations and must not be treated as independent animals. Source spot
and run identifiers are retained, including the anomalous F1D4 E21 spot
label. Assignment.pdf corroborates that complex-glycan codes omit the
Man 3GlcNAc 2 core, whereas H5N2/H6N2 are full compositions. The final
three source codes contain F1 but the diagram lacks fucose; their typed
molecular annotation is missing while source labels and amounts remain
intact. Unlocalized O-acetylation is represented at composition level
only. Quantitative values are preserved in the reported pmol scale.

Source-derived compositions and original labels are retained. 6
source-supported structures are typed; unspecified bonds remain unknown.
Unresolved or conflicting structures remain missing with source
provenance.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
