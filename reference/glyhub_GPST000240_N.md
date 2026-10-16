# Brugia malayi N-glycans across life stages

MALDI-TOF MS peak-area profiles of released glycans from mixed-sex adult
worms, microfilariae, adult females and adult males, and L3 larvae.

## Usage

``` r
glyhub_GPST000240_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 47 features and 9 observations. The abundance assay is in MALDI-TOF
MS integrated peak area (arbitrary units). rowData includes a typed
glycan_structure column; features without a supported structure are NA.

## Source

GlycoPOST GPST000240. Supplementary Table S3, B - MALDI Raw Data. Study:
<https://doi.org/10.1016/j.mcpro.2022.100201>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000240>.

## Details

Forty-seven source-assigned molecular features are retained, including
features without a quantified assignment in a particular spectrum.
Mixed-sex adult and microfilarial material each have an original
spectrum and two explicitly labelled biological replicates.
Sex-separated adults and L3 larvae have one profile each. Areas are
preserved on the source instrumental scale. Unassigned or undetected
features remain missing; no zero filling or normalization is applied.
Source phosphorylcholine and glucuronic-acid composition components are
represented explicitly. Proposed structural diagrams are transcribed and
composition-checked against the same source feature rows. Unlabelled
bonds are unknown; source ambiguity braces are represented as floating
groups without selecting a particular attachment.

47 proposed source structures are encoded with unspecified linkages and
floating groups kept uncertain. Source compositions preserve Hex,
HexNAc, Fuc, GlcA and phosphorylcholine; analytical anthranilic-acid
labeling is recorded separately.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
