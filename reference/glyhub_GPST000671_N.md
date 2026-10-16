# N-glycomes of influenza-infected A549 organelle and secreted fractions

131 released N-glycan chromatographic features in organelle and secreted
protein fractions of A549 cells 24 hours after PR8 (H1N1), x31 (H3N2) or
mock infection.

## Usage

``` r
glyhub_GPST000671_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 131 features and 24 observations. The abundance assay is in
relative abundance fraction. rowData includes a typed glycan_structure
column; features without a supported structure are NA.

## Source

GlycoPOST GPST000671. . Study:
<https://doi.org/10.1038/s42003-026-10759-y>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000671>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000671.0/Supplementary%20File_4_Glycomics.xlsx>.

## Details

PGC-LC-MS/MS glycan abundances are author-normalized proportions of all
glycans in each sample. Compatible organelle and secreted fractions are
combined with explicit compartment and infection metadata. Four
biological replicates per condition were planned. The O-glycan secreted
x31 block contains only two observations in the deposited quantitative
table; missing observations are not invented. Source isomer identifiers
and diagnostic evidence are retained. The deposited N-glycan table
contains 131 quantitative features, whereas the publication describes
142 identified N-glycan structures; this object reproduces the available
quantitative matrix rather than claiming to include undocumented
features. The corresponding molecular feature blocks in official
Supplementary Data 4 were checked cell-by-cell and match the deposited
workbook.

Source monosaccharide counts and author GlyTouCan accessions are
retained. Where an accession resolves to a parseable WURCS structure
with composition consistent with the source row, its structure is
included. Unresolvable accessions, incompatible compositions and rows
without sequence-level structure remain unfilled. Sulfate/phosphate
identity is resolved only when the row explicitly names it; ambiguous
substitution remains source annotation without a falsely complete
composition. Glycans were chemically reduced for measurement; structures
represent the source-referenced glycan identity.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
