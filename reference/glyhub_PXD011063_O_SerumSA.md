# Glyco-DIA SA serum source precursor peak areas

Glyco-DIA SA serum source precursor peak areas

## Usage

``` r
glyhub_PXD011063_O_SerumSA(
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

93,442 source feature rows across 6 reported measurement columns.

Assay scale: Source FG.MS2TotalPeakArea; untransformed MS2
chromatographic peak area

Feature grain: Library / precursor / decoy flag; all source row
associations retained

Source selection: Original Spectronaut peak areas preferred over
author-added Abundance and derived summary statistics

No normalization, logarithm, imputation, zero conversion, confidence
filtering or numerical aggregation

Repeated DDA-association rows are represented by their shared
quantitative cell only after exact MS1/MS2 equality is proven; no value
averaging or conflict resolution

Every source association remains linked by file and row; a missing
precursor/run pair becomes structural NA

Source decoy rows retained and flagged; biological independence of runs
is not inferred from filenames

Source modified sequence and glycopeptide label retained; no glycan
composition inferred solely from rounded mass

Upstream extraction and interference handling are not fully documented
in these exports

Measurement columns are not automatically independent biological
samples. Source row identifiers, annotations and provenance are retained
in metadata.

The assay preserves source numeric values. The metadata field
raw_abundance means source numbers; it does not certify that the authors
supplied unprocessed intensity.

Only the SA source file is included, across six reported runs. The deSA
source CSV contains independently confirmed embedded NUL bytes and an
unparsable quantitative record; it is excluded, not repaired or
filtered. All source decoys are retained and flagged. Biological
independence and exact glycan compositions remain unassigned.

## Availability and source license

Downloaded from the existing data release through the verified cache.
Deposited PRIDE source data are CC0-1.0, explicitly declared in the
project API. Cite the original authors and accession; see metadata
redistribution and source provenance.

## See also

[`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md),
[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
