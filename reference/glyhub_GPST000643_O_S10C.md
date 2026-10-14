# Replicated GH20 measurements of PSGL-1 O-glycan core features

O-glycan core measurements from pretreated PSGL-1 expressing core 4,
used to compare selected Bacteroides thetaiotaomicron GH20 enzymes.
Supplementary Table S10C provides three source-labelled samples for four
enzyme treatments and a control. This object contains the three O-glycan
features across those 15 observations.

## Usage

``` r
glyhub_GPST000643_O_S10C
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 3 features and 15 observations. The abundance assay is in
percentage of source total glycan AUC.

## Source

GlycoPOST GPST000643. Supplementary Table S10C, O-glycan rows 8-10
(media-11.xlsx); classification supported by S10B O-glycan rows 10, 14
and 15. Study: <https://doi.org/10.64898/2026.03.26.714468>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000643>.

## Details

The conditions are control, BT3178, BT3598, BT3868 and BT4681, each with
Sample 1, Sample 2 and Sample 3. PSGL-1 expressing core 4 was pretreated
with an enzyme mix. The expression-system species and biological versus
technical replicate type are not established by these table columns.
Percentages retain the source total-AUC denominator without
renormalization after separation by glycan class.

The retained mass-labelled features are 425-2, 628 and 716 (source rows
8-10). Their composition and full putative-structure labels match the
explicitly labelled O-glycan section of S10B. The two N-glycan features
from S10C are available in glyhub_GPST000643_N_S10C. Both objects
describe the same observation columns; they are complementary feature
partitions, not separate biological samples.

All three source compositions and putative structures are encoded.
Reduced termini follow the source assignments.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
