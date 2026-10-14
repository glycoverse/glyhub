# Fucosidase treatment of porcine colonic mucin O-glycans

LC-MS profiles of porcine colonic mucin oligosaccharides exposed to
individual Bacteroides thetaiotaomicron fucosidases. This experiment
compares the effects of GH95 and GH29 enzymes on a complex O-glycan
substrate containing different fucosylated epitopes. Supplementary Table
S5 provides 108 features and 22 observations.

## Usage

``` r
glyhub_GPST000643_O_S5
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 108 features and 22 observations. The abundance assay is in
percentage of source total glycan AUC.

## Source

GlycoPOST GPST000643. Supplementary Table S5 (media-6.xlsx). Study:
<https://doi.org/10.64898/2026.03.26.714468>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000643>.

## Details

The conditions are a no-enzyme control and BT1777, BT3155, BT3173,
BT1842, BT3665, BT1625, BT4136, BT3798, BT3956 and BT4713. Each
condition has columns labelled Replicate 1 and Replicate 2; these labels
alone do not identify biological versus technical replicates.

The source supplies glycan AUCs, retention times and percentages
normalized to total glycan AUC per observation. The abundance assay uses
the percentages. Fucose, sulfation and blood-group annotations are
retained as source annotations, including their zero-valued categorical
flags. Features include substrate glycans and enzymatic products;
O-derived denotes their experimental origin.

All 108 source composition labels are retained as typed compositions.
Forty-seven source putative structures have explicit encodings;
remaining structural descriptions are preserved as text without
completing unspecified linkages.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
