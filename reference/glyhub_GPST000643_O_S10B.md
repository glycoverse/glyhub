# GH20 activity on O-glycans from pretreated PSGL-1

O-glycan measurements from P-selectin glycoprotein ligand-1 (PSGL-1)
expressing core 4 after pretreatment and exposure to Bacteroides
thetaiotaomicron GH20 enzymes. This screening experiment examines
removal of exposed N-acetylglucosamine from O-glycan core structures.
The O-glycan section of Supplementary Table S10B supplies nine features
across eight conditions.

## Usage

``` r
glyhub_GPST000643_O_S10B
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 9 features and 8 observations. The abundance assay is in percentage
of source total glycan AUC.

## Source

GlycoPOST GPST000643. Supplementary Table S10B, O-glycan rows 9-17
(media-11.xlsx). Study: <https://doi.org/10.64898/2026.03.26.714468>.
Repository: <https://glycopost.glycosmos.org/entry/GPST000643>.

## Details

The protein substrate was pretreated with BT0455 sialidase and the
galactosidases BT1626 and BT4241 to expose terminal N-acetylglucosamine.
The eight conditions are control, BT1621, BT1627, BT3178, BT3598,
BT3868, BT4394 and BT4681. There is one source column per condition;
biological replicate type and expression-system species are not
established by these table columns.

Only the source O-glycan section is included here. Its N-glycan section
is available as glyhub_GPST000643_N_S10B. Percentages retain the
denominator supplied in the workbook; separating the sections does not
renormalize either matrix. Source mass/isomer labels are local to the
table and are not universal glycan identifiers.

All nine source compositions and putative structures have typed
representations, including reduced termini where specified.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
