# Schistosoma mansoni adult-worm source N-glycan-site abundance

Schistosoma mansoni adult-worm source N-glycan-site abundance

## Usage

``` r
glyhub_MSV000097695_N_AdultWorm(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 3274 source rows and 6 measurements.

## Source

<https://doi.org/10.1038/s41467-026-68400-9>. MassIVE deposited dataset:
CC0-1.0; not the publisher supplement license

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

Three female-labelled and three male-labelled whole-adult-worm
measurements. Replicate biological independence is not reported. The
study's tissue-specific transcriptomic analyses do not imply
tissue-resolved mass-spectrometry samples. All 3,274 source
site/composition rows are retained. Ambiguous protein/site groups are
not expanded or assigned a guessed single accession or position. Author
downstream protein normalization and Perseus processing are not
reapplied.

Source scale: Author pGlycoQuant site-specific glycan abundance; before
subsequent protein-ratio normalization and Perseus
log2/filtering/imputation.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Available from the versioned `data-v0.2.0` GitHub data release.
Downloads are verified by file size and SHA-256 and cached for offline
reuse.
