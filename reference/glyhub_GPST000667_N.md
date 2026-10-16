# N-glycan profiles of A549 and BEAS-2B small extracellular vesicles and culture media

GlycoGenius-derived N-glycan abundance profiles from tumorigenic A549
and non-tumorigenic BEAS-2B small extracellular vesicles, with BEGM and
F12 culture-medium profiles from the same study.

## Usage

``` r
glyhub_GPST000667_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 271 features and 4 observations. The abundance assay is in
GlycoGenius abundance. rowData has no glycan_structure column because no
feature has a supported structural annotation.

## Source

GlycoPOST GPST000667. . Study:
<https://doi.org/10.1016/j.mcpro.2026.101524>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000667>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000667.0/N-glycan-identifications.csv>.

## Details

All four source profile columns are retained. These are single profiles
rather than six-replicate glycoproteomic measurements reported elsewhere
in the paper. Migration-time-filtered assignments can contain
alternative compositions separated by slashes; those alternatives remain
explicit and are not arbitrarily resolved. Missing medium signals remain
NA. This accession shares its publication with GPST000562, whose CS/DS
disaccharides are represented separately because the glycan type and
quantification differ.

H, N and F encode Hex, HexNAc and Fuc. Am and E encode derivatized
alpha2,3 and alpha2,6 Neu5Ac; native NeuAc totals are represented as
composition, and derivative/linkage counts are retained. Phosphorylation
is retained where explicitly reported. Features with incompatible
alternative compositions have missing typed composition and retain every
author candidate.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
