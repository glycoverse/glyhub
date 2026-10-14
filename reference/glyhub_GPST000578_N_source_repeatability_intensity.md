# Ovalbumin N-glycan repeatability profiles and related study experiments

Complete Ovalbumin source feature block from the Figure 4b
sample-preparation repeatability assay. Three technical preparations are
retained separately; average, standard deviation and CV are not samples.
This panel is distinct from similarly named immunoglobulin application
samples in Figure 5bc. Combined N-glycan quantitative profiles from
GPST000578. 41 union features and 12 source observations are
represented.

## Usage

``` r
glyhub_GPST000578_N_source_repeatability_intensity
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 41 features and 12 observations. The abundance assay is in glycan
intensity (source values). rowData includes a typed glycan_structure
column; features without a supported structure are NA.

## Source

GlycoPOST GPST000578. Figure 4b. Study:
<https://doi.org/10.1038/s41467-026-73091-3>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000578>. Quantitative source:
<https://media.springernature.com/original/springer-static/esm/art%3A10.1038%2Fs41467-026-73091-3/MediaObjects/41467_2026_73091_MOESM4_ESM.xls>.

## Details

Source experiments are identified in colData and original panel-specific
metadata, annotations and measurements are retained in metadata. Feature
identities are aligned only when supported by author identifiers or
explicit molecular structures; other features retain source-specific
identities. The source_coverage matrix distinguishes unmeasured
combinations from measured missing values. Units: glycan intensity
(source values).

Ovalbumin N-glycan repeatability profiles: Complete Ovalbumin source
feature block from the Figure 4b sample-preparation repeatability assay.
Three technical preparations are retained separately; average, standard
deviation and CV are not samples. This panel is distinct from similarly
named immunoglobulin application samples in Figure 5bc. Quantitative
zeros are represented as NA without imputation or renormalization;
original measurements are retained. GlyTouCan identifiers remain the
source assignments. The readxl 1.5.0.1 reader substitutes embedded chart
cache values into ten worksheet cells C3:C12. The original XLS is
unchanged; all 1516 selected measurements agree exactly with
independently decoded worksheet records. This is a reader issue, not an
author-data conflict.

Xolair N-glycan repeatability profiles: Complete Xolair source feature
block from the Figure 4b sample-preparation repeatability assay. Three
technical preparations are retained separately; average, standard
deviation and CV are not samples. This panel is distinct from similarly
named immunoglobulin application samples in Figure 5bc. Quantitative
zeros are represented as NA without imputation or renormalization;
original measurements are retained. GlyTouCan identifiers remain the
source assignments. The readxl 1.5.0.1 reader substitutes embedded chart
cache values into ten worksheet cells C3:C12. The original XLS is
unchanged; all 1516 selected measurements agree exactly with
independently decoded worksheet records. This is a reader issue, not an
author-data conflict.

Fetuin N-glycan repeatability profiles: Complete Fetuin source feature
block from the Figure 4b sample-preparation repeatability assay. Three
technical preparations are retained separately; average, standard
deviation and CV are not samples. This panel is distinct from similarly
named immunoglobulin application samples in Figure 5bc. Quantitative
zeros are represented as NA without imputation or renormalization;
original measurements are retained. GlyTouCan identifiers remain the
source assignments. The readxl 1.5.0.1 reader substitutes embedded chart
cache values into ten worksheet cells C3:C12. The original XLS is
unchanged; all 1516 selected measurements agree exactly with
independently decoded worksheet records. This is a reader issue, not an
author-data conflict.

hIgG N-glycan repeatability profiles: Complete hIgG source feature block
from the Figure 4b sample-preparation repeatability assay. Three
technical preparations are retained separately; average, standard
deviation and CV are not samples. This panel is distinct from similarly
named immunoglobulin application samples in Figure 5bc. Quantitative
zeros are represented as NA without imputation or renormalization;
original measurements are retained. GlyTouCan identifiers remain the
source assignments. The readxl 1.5.0.1 reader substitutes embedded chart
cache values into ten worksheet cells C3:C12. The original XLS is
unchanged; all 1516 selected measurements agree exactly with
independently decoded worksheet records. This is a reader issue, not an
author-data conflict.

All source GlyTouCan identifiers resolve to WURCS through the official
GlyTouCan SPARQL service. Structures are converted with glyparse 0.8.1
and validated with glyrepr 1.1.0, and compositions are derived from the
validated structures. No mass-based assignments or new experimental
linkage evidence are inferred.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
