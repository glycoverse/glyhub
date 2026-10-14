# Sialylation of bovine fetuin N-glycans in an enzyme reactor

N-glycan profiles from desialylated bovine fetuin passed through an
immobilised ST6GAL1 reactor. The experiment follows redistribution among
sialylated forms of three precursor families during repeated injections
at 25 and 75 microlitres/minute. Ten glycan features are represented
across 28 source observations.

## Usage

``` r
glyhub_GPST000738_N_ST6GAL1
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 10 features and 28 observations. The abundance assay is in fraction
within the source precursor glycan family.

## Source

GlycoPOST GPST000738. Supplementary Table 1, sheets 3 and 4; composition
comparisons in sheets 7 and 8; Figure S3. Study:
<https://doi.org/10.3389/fmolb.2026.1932584>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000738>.

## Details

Seven substrate-control columns accompany seven reactor observations at
25 microlitres/minute and fourteen at 75 microlitres/minute. Injection
times are 0, 2, 4 and 8 hours. The 25 microlitres/minute series has one
0-hour column and two at each later time; the 75 microlitres/minute
series has four at 0, 2 and 8 hours and two at 4 hours.

Values are fractions within the H6N5, H5N5 or H5N4 precursor family.
They must not be interpreted as total-glycome fractions or mixed
directly with the percentage scale of the B4GalT1 dataset.

Thirteen source n.d. values are NA. Ten 25 microlitres/minute 0-hour
measurements are also NA because their omission from processed sheet 7
is unexplained. An extra processed-table control lacks a raw-table
identity and remains in metadata as unmatched observations. The repeated
control table is represented once; biological replicate type is
unresolved.

Ten typed compositions describe sialylated forms. Four fully localized
Figure S3 structures are encoded; diagrams retain the evidence for
unresolved positional forms.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
