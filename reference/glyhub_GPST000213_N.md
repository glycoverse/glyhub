# Mouse CTX (M) N-glycan source peak profiles and related study experiments

Complete source-defined N-glycan peak-intensity matrix for mouse CTX
(M). The repository includes wild-type and Slc39a8 A391T mutant
observations; specimen labels and source genotypes are retained where
given. Combined N-glycan quantitative profiles from GPST000213. 679
union features and 86 source observations are represented.

## Usage

``` r
glyhub_GPST000213_N(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 679 features and 86 observations. The abundance assay is in source
peak intensity. rowData has no glycan_structure column because no
feature has a supported structural annotation.

## Source

GlycoPOST GPST000213. CTX (M). Study:
<https://doi.org/10.1038/s41467-021-27781-9>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000213>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000213.0/Source%20Data%20N-Glycans.xlsx>.
Related study: <https://doi.org/10.1038/s41380-022-01490-1>.

## Arguments

- kind:

  `"curated"` returns a data object; `"raw"` returns the path to a
  verified source archive. Raw archives are currently available for
  CPTAC.

- cache_dir:

  Cache directory, defaulting to `tools::R_user_dir("glyhub", "cache")`.
  Set option `glyhub.cache_dir` to change the default.

- refresh:

  Download the pinned resource again, even if cached.

- offline:

  Prohibit downloads; require a verified local resource.

## Details

Source experiments are identified in colData and original panel-specific
metadata, annotations and measurements are retained in metadata. Feature
identities are aligned only when supported by author identifiers or
explicit molecular structures; other features retain source-specific
identities. The source_coverage matrix distinguishes unmeasured
combinations from measured missing values. Units: source peak intensity.

Mouse CTX (M) N-glycan source peak profiles: 130 quantified source peaks
are retained, including peaks without resolved molecular annotation.
This is the complete raw-intensity block of the processed workbook, not
raw MS reprocessing. Peaks are indexed within the source sheet; no
mass-tolerance matching or inter-tissue alignment is imposed. Published
normalized and signal-to-noise tables remain in the original workbook;
they are not substituted for the intensity assay. Sex and specimen
labels are source-defined. Glycan composition is unknown for these
peak-level features because the separate rounded-mass annotation list
has no exact source feature key. Source QC: the full 130-value
raw-intensity vectors for M480 (WT, source G) and M11 (MUT, source I)
are identical, as are M10 (MUT, source H) and M444 (MUT, source K). All
four source columns are preserved, but their analysis assay values are
masked as NA because source sample provenance cannot be resolved. No
member of either pair is guessed to be correct. The repository combines
wild-type profiling with Slc39a8 A391T data discussed in the related
study (DOI: 10.1038/s41380-022-01490-1); the linked Nature
Communications data-availability statement explicitly identifies this
shared accession.

Mouse HIP (M) N-glycan source peak profiles: 130 quantified source peaks
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

Mouse STR (M) N-glycan source peak profiles: 130 quantified source peaks
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

Mouse CBLM (M) N-glycan source peak profiles: 130 quantified source
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

Mouse CTX (F) N-glycan source peak profiles: 130 quantified source peaks
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

Mouse CBLM (F) N-glycan source peak profiles: 130 quantified source
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

Mouse Plasma (M F) N-glycan source peak profiles: 29 quantified source
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

## Access

Use `glyhub_load("glyhub_GPST000213_N")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
