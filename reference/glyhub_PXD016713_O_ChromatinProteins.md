# GalNAz-enriched chromatin proteins in MCF-7 and resistant cells

GalNAz-enriched chromatin proteins in MCF-7 and resistant cells

## Usage

``` r
glyhub_PXD016713_O_ChromatinProteins(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 1952 source rows and 18 measurements.

## Source

<https://doi.org/10.1038/s41467-020-19579-y>. CC BY 4.0 author
supplement, no exclusion found; evidence in license_evidence.json

## Arguments

- kind:

  `"curated"` returns a data object; `"raw"` returns the path to a
  verified source file. Here `"raw"` means the source asset, not
  necessarily instrument-raw or unprocessed intensity. Some literature
  sources contain signed author-processed matrices and have no curated
  object.

- cache_dir:

  Cache directory, defaulting to `tools::R_user_dir("glyhub", "cache")`.
  Set option `glyhub.cache_dir` to change the default.

- refresh:

  Download the pinned resource again, even if cached.

- offline:

  Prohibit downloads; require a verified local resource.

## Details

Complete selected author protein-level glyco-enrichment matrix, not
intact glycopeptide or quantified glycosite data. Methods explicitly say
proteins present \>=6/9 replicates in \>=1 group and missing values
imputed from normal distribution (downshift 1.8 SD,width 0.3 SD);
already-imputed source values retained, not claimed raw unprocessed
intensities Article Fig1e labels n=9 biologically independent; methods
say nine biological replicates. Two-level source suffixes retained
verbatim, not collapsed or assumed to establish batches/pairing; no
subject identifiers or independent-donor claim. Source identifiers and
annotations retained; no glycan composition, topology or site inferred.

Source scale: author-imputed positive linear MaxQuant protein intensity.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Available from the versioned `data-v0.2.0` GitHub data release.
Downloads are verified by file size and SHA-256 and cached for offline
reuse.
