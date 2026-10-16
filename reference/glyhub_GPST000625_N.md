# Human intervertebral-disc N-glycan chromatographic profiles

Thirty-two shared HILIC-UPLC N-glycan peaks quantified in six biological
replicates each of healthy and degenerated annulus fibrosus and nucleus
pulposus tissue.

## Usage

``` r
glyhub_GPST000625_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 32 features and 24 observations. The abundance assay is in relative
peak area (%). rowData has no glycan_structure column because no feature
has a supported structural annotation.

## Source

GlycoPOST GPST000625. UPLC_covariance_bio replicates. Study:
<https://doi.org/10.1002/advs.202506669>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000625>.

## Details

Dataset S2 contains the full individual-replicate percentage-area
matrix. Glycan peaks may contain coeluting species, so peak identities
are retained without assigning a single composition or structure. The
separate 48-peak pooled-sample structural-deconvolution analysis is
retained in the source workbook and is not equated to the 32-peak
individual-replicate feature space. No glycan identities are inferred
from peak numbers.

UPLC peak-level quantitative features; 32 individual-sample peaks cannot
be uniquely matched to 48 pooled structural fractions. Composition and
structure are intentionally missing; source peak identities are
retained.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
