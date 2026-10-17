# Mouse brain Glyco-Decipher chromatographic areas

Mouse brain Glyco-Decipher chromatographic areas

## Usage

``` r
glyhub_IPX0011099000_N_Brain(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Source

<https://doi.org/10.1038/s41467-025-60437-6>.

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

20,191 source feature rows across 60 reported measurement columns.

Assay scale: Source untransformed chromatographic Area

Feature grain: Peptide / glycan / source sites / compensation voltage

Source selection: Raw Area exports preferred over Supplementary Data6
processed matrix

No normalization, log transform, imputation, filtering, aggregation or
zero conversion

Exact source identity union; a row absent from a run becomes structural
NA; reported zero remains zero

Separate FAIMS compensation voltages retained as separate features

Unambiguous single accession@position parsed; multiple site assignments
retained verbatim with canonical NA

Run code and region code retained without guessing disease, age, or
anatomical mapping

Source extraction and identification filtering precede these exports;
unspecified extraction settings remain unknown

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
