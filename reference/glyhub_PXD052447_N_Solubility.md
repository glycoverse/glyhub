# DQGlyco mouse brain solubility reporter intensities

DQGlyco mouse brain solubility reporter intensities

## Usage

``` r
glyhub_PXD052447_N_Solubility(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Source

<https://doi.org/10.1038/s41594-025-01485-w>.

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

89,115 source feature rows across 18 reported measurement columns.

Assay scale: Deposited untransformed PSM-level TMT reporter intensities

Feature grain: PSM; all deposited rows retained, including rows without
glycan annotation

Source selection: Deposited reporter intensities preferred over
normalized supplementary glycopeptide matrices or ratios

No normalization, logarithm, imputation, filtering, aggregation or zero
conversion

Source blanks are NA; numeric zero retained with no interpretation of
its missingness semantics

All 18 deposited reporter channels retained; unmatched channel roles
remain unknown

PSM counts are not counts of unique glycopeptides; no peptide-level
aggregation performed

Protein sites are not inferred from peptide coordinates; original search
annotations are retained

Source search/FDR and reporter extraction precede this deposit; any
undocumented upstream correction remains unknown

Measurement columns are not automatically independent biological
samples. Source row identifiers, annotations and provenance are retained
in metadata.

The assay preserves source numeric values. The metadata field
raw_abundance means source numbers; it does not certify that the authors
supplied unprocessed intensity.

All deposited PSM rows are retained, including rows without a glycan
annotation. All source reporter channels are retained; unmapped channels
have unknown sample roles. Consult sample_annotation_matched before
comparing biological groups.

## Availability and source license

Downloaded from the existing data release through the verified cache.
Deposited PRIDE source data are CC0-1.0, explicitly declared in the
project API. Cite the original authors and accession; see metadata
redistribution and source provenance.

## See also

[`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md),
[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
