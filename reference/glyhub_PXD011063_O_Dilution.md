# Glyco-DIA precursor peak areas in a dilution experiment

Glyco-DIA precursor peak areas in a dilution experiment

## Usage

``` r
glyhub_PXD011063_O_Dilution(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Source

<https://doi.org/10.1038/s41592-019-0504-x>.

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

15,890 source feature rows across 10 reported measurement columns.

Assay scale: Source FG.MS2TotalPeakArea; untransformed summed MS2
fragment chromatographic peak area

Feature grain: Library-specific precursor and source decoy flag; source
decoys retained and explicitly flagged

Source selection: MS2TotalPeakArea preferred over FG.Quantity,
EG.TotalQuantity and supplementary glycopeptide quantities; MS1PeakArea
retained in metadata

No normalization, log transform, imputation, zero conversion, confidence
filtering or aggregation

Union of exact library/precursor/decoy keys; absent report rows become
structural NA, not zero

Source decoy rows and unquantified or unidentified rows retained; use
source flags before biological inference

Different libraries are alternative analyses, not independent biological
samples

No glycan composition inferred solely from rounded modification mass;
source modified sequence retained

Spectronaut extraction, interference handling and upstream settings are
not fully recoverable from these exports

Measurement columns are not automatically independent biological
samples. Source row identifiers, annotations and provenance are retained
in metadata.

The assay preserves source numeric values. The metadata field
raw_abundance means source numbers; it does not certify that the authors
supplied unprocessed intensity.

Source decoys are retained and flagged; this is an unfiltered
source-report representation, not a confidence-filtered biological
feature set.

## Availability and source license

Downloaded from the existing data release through the verified cache.
Deposited PRIDE source data are CC0-1.0, explicitly declared in the
project API. Cite the original authors and accession; see metadata
redistribution and source provenance.

## See also

[`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md),
[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
