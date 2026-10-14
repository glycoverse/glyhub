# GH20 activity on N-glycans from pretreated PSGL-1

The N-glycan fraction reported alongside the PSGL-1 GH20 enzyme screen.
These measurements describe three N-glycan features with exposed
N-acetylglucosamine in the pretreated glycoprotein preparation,
permitting inspection of enzyme responses outside the O-glycan core
panel. Supplementary Table S10B reports the three features across eight
conditions.

## Usage

``` r
glyhub_GPST000643_N_S10B
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 3 features and 8 observations. The abundance assay is in percentage
of source total glycan AUC.

## Source

GlycoPOST GPST000643. Supplementary Table S10B, N-glycan rows 25-27
(media-11.xlsx). Study: <https://doi.org/10.64898/2026.03.26.714468>.
Repository: <https://glycopost.glycosmos.org/entry/GPST000643>.

## Details

The protein substrate was pretreated with BT0455 sialidase and the
galactosidases BT1626 and BT4241 to expose terminal N-acetylglucosamine.
The eight conditions are control, BT1621, BT1627, BT3178, BT3598,
BT3868, BT4394 and BT4681. There is one source column per condition;
biological replicate type and expression-system species are not
established by these table columns.

This object follows the workbook's explicit N-glycan classification
rather than combining these features with its O-glycan section. It is
not a separate set of eight biological samples inferred from that split.
The source percentages are preserved without changing their denominator.
Compare glyhub_GPST000643_O_S10B for the complementary feature space.

The three composition labels and putative structures are encoded,
including the source reduced reducing ends.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
