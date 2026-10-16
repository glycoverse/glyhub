# CS/DS disaccharide amounts in A549 and BEAS-2B small extracellular vesicles

Four chondroitin/dermatan sulfate disaccharides quantified as fmol in
five A549 and six BEAS-2B small-extracellular-vesicle preparations.

## Usage

``` r
glyhub_GPST000562_CS_DS
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 4 features and 11 observations. The abundance assay is in fmol.
rowData has no glycan_structure column because no feature has a
supported structural annotation.

## Source

GlycoPOST GPST000562. . Study:
<https://doi.org/10.1016/j.mcpro.2026.101524>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000562>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000562.0/identification_quantification_table.xlsx>.

## Details

Amounts derive from enzymatic CS/DS depolymerization and LC-MS/MS
integration. D0a4 and D0a6 were distinguished by diagnostic fragments;
the original 11 quantitative observations are preserved. The publication
reports six preparations per cell line but excludes one A549 CS/DS
preparation after a presumed preparation failure; the absent A5
observation is not manufactured. The N-glycan profiles from the same
paper are stored under GPST000667.

Author CS/DS disaccharide codes and sulfate positions are retained. The
measured lyase products contain an unsaturated uronic acid that the
installed glyrepr vocabulary cannot represent faithfully; typed
compositions therefore remain missing rather than substituting saturated
HexA. D0a0, D0a4, D0a6 and D0a10 denote zero, 4-O, 6-O and
4,6-di-O-sulfation, respectively.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
