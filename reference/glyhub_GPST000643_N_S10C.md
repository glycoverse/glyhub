# Replicated GH20 measurements of PSGL-1 N-glycan features

N-glycan measurements accompanying the replicated GH20 enzyme comparison
on pretreated PSGL-1. The two features describe exposed
N-acetylglucosamine-containing N-glycans measured alongside the O-glycan
core panel. Supplementary Table S10C supplies the same 15 observation
columns for these two features.

## Usage

``` r
glyhub_GPST000643_N_S10C
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 2 features and 15 observations. The abundance assay is in
percentage of source total glycan AUC.

## Source

GlycoPOST GPST000643. Supplementary Table S10C, N-glycan rows 11-12
(media-11.xlsx); classification supported by S10B N-glycan rows 25-26.
Study: <https://doi.org/10.64898/2026.03.26.714468>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000643>.

## Details

The conditions are control, BT3178, BT3598, BT3868 and BT4681, each with
Sample 1, Sample 2 and Sample 3. PSGL-1 expressing core 4 was pretreated
with an enzyme mix. The expression-system species and biological versus
technical replicate type are not established by these table columns.
Percentages retain the source total-AUC denominator without
renormalization after separation by glycan class.

Mass-labelled features 1317-1 and 1520 are source rows 11 and 12. Their
compositions and complete putative-structure text are identical to S10B
rows 25 and 26, located under its explicit N-glycans heading. This
source correspondence supports the N classification independently of
mass alone. The companion glyhub_GPST000643_O_S10C object contains the
other three rows; the matrices share their observation identities and
must not be counted as separate samples.

Both source compositions and putative N-glycan structures are encoded,
retaining the reduced reducing ends.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
