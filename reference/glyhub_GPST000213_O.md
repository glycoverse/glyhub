# Mouse CTX (M) O-glycan source peak profiles and related study experiments

Complete source-defined O-glycan peak-intensity matrix for mouse CTX
(M). The repository includes wild-type and Slc39a8 A391T mutant
observations; specimen labels and source genotypes are retained where
given. Combined O-glycan quantitative profiles from GPST000213. 148
union features and 39 source observations are represented.

## Usage

``` r
glyhub_GPST000213_O
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 148 features and 39 observations. The abundance assay is in source
peak intensity. rowData has no glycan_structure column because no
feature has a supported structural annotation.

## Source

GlycoPOST GPST000213. CTX (M). Study:
<https://doi.org/10.1038/s41467-021-27781-9>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000213>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000213.0/Source%20Data%20O-Glycans.xlsx>.
Related study: <https://doi.org/10.1038/s41380-022-01490-1>.

## Details

Source experiments are identified in colData and original panel-specific
metadata, annotations and measurements are retained in metadata. Feature
identities are aligned only when supported by author identifiers or
explicit molecular structures; other features retain source-specific
identities. The source_coverage matrix distinguishes unmeasured
combinations from measured missing values. Units: source peak intensity.

Mouse CTX (M) O-glycan source peak profiles: 30 quantified source peaks
are retained, including peaks without resolved molecular annotation.
This is the complete raw-intensity block of the processed workbook, not
raw MS reprocessing. Peaks are indexed within the source sheet; no
mass-tolerance matching or inter-tissue alignment is imposed. Published
normalized and signal-to-noise tables remain in the original workbook;
they are not substituted for the intensity assay. Sex and specimen
labels are source-defined. Glycan composition is unknown for these
peak-level features because the separate rounded-mass annotation list
has no exact source feature key. The repository combines wild-type
profiling with Slc39a8 A391T data discussed in the related study (DOI:
10.1038/s41380-022-01490-1); the linked Nature Communications
data-availability statement explicitly identifies this shared accession.

Mouse HIP (M) O-glycan source peak profiles: 30 quantified source peaks
are retained, including peaks without resolved molecular annotation.
This is the complete raw-intensity block of the processed workbook, not
raw MS reprocessing. Peaks are indexed within the source sheet; no
mass-tolerance matching or inter-tissue alignment is imposed. Published
normalized and signal-to-noise tables remain in the original workbook;
they are not substituted for the intensity assay. Sex and specimen
labels are source-defined. Glycan composition is unknown for these
peak-level features because the separate rounded-mass annotation list
has no exact source feature key. The repository combines wild-type
profiling with Slc39a8 A391T data discussed in the related study (DOI:
10.1038/s41380-022-01490-1); the linked Nature Communications
data-availability statement explicitly identifies this shared accession.

Mouse STR (M) O-glycan source peak profiles: 30 quantified source peaks
are retained, including peaks without resolved molecular annotation.
This is the complete raw-intensity block of the processed workbook, not
raw MS reprocessing. Peaks are indexed within the source sheet; no
mass-tolerance matching or inter-tissue alignment is imposed. Published
normalized and signal-to-noise tables remain in the original workbook;
they are not substituted for the intensity assay. Sex and specimen
labels are source-defined. Glycan composition is unknown for these
peak-level features because the separate rounded-mass annotation list
has no exact source feature key. The repository combines wild-type
profiling with Slc39a8 A391T data discussed in the related study (DOI:
10.1038/s41380-022-01490-1); the linked Nature Communications
data-availability statement explicitly identifies this shared accession.

Mouse CBLM (M) O-glycan source peak profiles: 30 quantified source peaks
are retained, including peaks without resolved molecular annotation.
This is the complete raw-intensity block of the processed workbook, not
raw MS reprocessing. Peaks are indexed within the source sheet; no
mass-tolerance matching or inter-tissue alignment is imposed. Published
normalized and signal-to-noise tables remain in the original workbook;
they are not substituted for the intensity assay. Sex and specimen
labels are source-defined. Glycan composition is unknown for these
peak-level features because the separate rounded-mass annotation list
has no exact source feature key. The repository combines wild-type
profiling with Slc39a8 A391T data discussed in the related study (DOI:
10.1038/s41380-022-01490-1); the linked Nature Communications
data-availability statement explicitly identifies this shared accession.

Mouse CTX (Female) O-glycan source peak profiles: 28 quantified source
peaks are retained, including peaks without resolved molecular
annotation. This is the complete raw-intensity block of the processed
workbook, not raw MS reprocessing. Peaks are indexed within the source
sheet; no mass-tolerance matching or inter-tissue alignment is imposed.
Published normalized and signal-to-noise tables remain in the original
workbook; they are not substituted for the intensity assay. Sex and
specimen labels are source-defined. Glycan composition is unknown for
these peak-level features because the separate rounded-mass annotation
list has no exact source feature key. The repository combines wild-type
profiling with Slc39a8 A391T data discussed in the related study (DOI:
10.1038/s41380-022-01490-1); the linked Nature Communications
data-availability statement explicitly identifies this shared accession.

No molecular annotation is inferred from mass alone; source m/z labels
remain available.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
