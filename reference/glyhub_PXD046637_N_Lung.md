# Paired lung nodule glycoproteomics

Paired lung nodule glycoproteomics

## Usage

``` r
glyhub_PXD046637_N_Lung(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Source

<https://doi.org/10.1038/s41467-025-57364-x>.

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

## Value

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html).

## Details

39,079 source feature rows across 165 reported measurement columns.

Assay scale: Deposited untransformed ion-level TMT reporter intensities;
author software aggregated PSMs to ions

Feature grain: Peptide Sequence / Modified Sequence / Charge / Observed
Modifications / Protein

Source selection: Raw deposited ion reporter table preferred. Processed
clinical matrix retained as explicit alternative in metadata because
original channel-to-patient mapping was not supplied in the inspected
files.

No additional normalization, logarithm, imputation, zero conversion,
confidence filtering or intensity aggregation

Exact molecular identity union across batches; an ion absent from a
batch becomes structural NA

All source ion rows, including rows without glycan annotations, and all
11 channels per batch retained

165 reporter channels are not 165 patients: reference/unused roles and
linkage to the 132 clinical specimens remain unresolved

Source annotation.txt only repeats channel labels; clinical specimen
labels are not guessed

Source PSM-to-ion summarization precedes this deposit; upstream
correction settings remain unverified

Unambiguous composition text parsed after removing its explicit terminal
mass; ambiguous modifications retain full text and typed NA

Measurement columns are not automatically independent biological
samples. Source row identifiers, annotations and provenance are retained
in metadata.

The assay preserves source numeric values. The metadata field
raw_abundance means source numbers; it does not certify that the authors
supplied unprocessed intensity.

## Availability and source license

Downloaded from the existing data release through the verified cache.
Source-license scope for the complete object remains unresolved; no new
license is granted. See publication-decisions.tsv and object metadata
for original sources and limitations.

## See also

[`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md),
[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
