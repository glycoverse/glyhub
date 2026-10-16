# Cornu aspersum mucus N-glycan profiles

Released glycans from adhesive, lubricating and protective snail mucus,
measured by glycomic mass spectrometry after per-deuter-O-methylation.

## Usage

``` r
glyhub_GPST000297_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 24 features and 3 observations. The abundance assay is in relative
glycan peak-area percentage. rowData includes a typed glycan_structure
column; features without a supported structure are NA.

## Source

GlycoPOST GPST000297. Supplementary Table 10 (PDF S47). Study:
<https://doi.org/10.1038/s41467-023-41094-z>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000297>.

## Details

All 25 reported rows of Supplementary Table 10 are retained across three
source mucus profiles. Values are the published glycan-peak area
percentages. Identical source mass/composition/topology assignments are
aligned across samples; conflicting masses or proposed isomers remain
distinct. Unreported combinations are missing and no renormalization is
applied. Each of the three reported N-glycan profiles totals 100%.
Native methyl substituents are preserved separately from analytical
derivatization. In Table 10 row 10, the diagram adds an outlined diamond
absent from the stated composition; row 11 draws two fucoses while its
composition states one. Typed composition and structure remain missing
for these two features without removing their quantitative observations.

22 proposed source structures retain unspecified linkages and
floating-group uncertainty. Native methyl groups remain explicit. Source
composition and structure are missing for conflicting N-glycan
assignments rather than selected by assumption.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
