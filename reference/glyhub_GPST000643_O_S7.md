# GH89 treatment of porcine gastric mucin O-glycans

Porcine gastric mucin oligosaccharide profiles used to compare the GH89
enzymes BT0438 and BT4359 from Bacteroides thetaiotaomicron. The
experiment investigates cleavage of terminal alpha-linked
N-acetylglucosamine groups on a complex mucin substrate. Supplementary
Table S7 contains 77 features across six observations.

## Usage

``` r
glyhub_GPST000643_O_S7
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 77 features and 6 observations. The abundance assay is in
percentage of source total glycan AUC.

## Source

GlycoPOST GPST000643. Supplementary Table S7 (media-8.xlsx). Study:
<https://doi.org/10.64898/2026.03.26.714468>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000643>.

## Details

The no-enzyme control, BT0438 treatment and BT4359 treatment each have
two source-labelled replicates. The assay contains total-AUC-normalized
percentages; original AUC and retention-time entries are retained
separately in metadata.

Source row 46 has a disagreement between its reported composition and
putative structure residue counts. Rows 69 and 70 contain the unresolved
composition token HexHAc, so their typed compositions are NA. Original
labels and the annotation_consistency field identify these cases. Their
quantitative measurements are retained; uncertain molecular assignments
should be considered before feature-level interpretation.

Seventy-five compositions are parsed and 67 putative structures are
encoded. Original structures and two unparsed composition labels remain
available in rowData.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
