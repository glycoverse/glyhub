# MCF10A EMT gene-level N-enriched surfaceome expression

MCF10A EMT gene-level N-enriched surfaceome expression

## Usage

``` r
glyhub_PXD031071_N_Surfaceome(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 549 source rows and 30 measurements.

## Source

<https://doi.org/10.1038/s41467-023-36122-x>. CC BY 4.0 original-author
GLYCO supplementary matrix; no separate exclusion identified. Format
conversion only.

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

Complete author GLYCO table: 549 genes and ten timepoints with three
biological replicates each. This is protein-enriched surfaceome
expression, not intact glycopeptide or glycosite quantification. Only
source gene labels are supplied; protein accessions, sites and glycan
compositions remain unknown. Authors describe log2 transformation,
normalization and LLS imputation; the precise stage of this published
sheet is unresolved. Values are retained without further processing and
are not raw intensity.

Source scale: author-processed log2 surfaceome expression; exact
published processing stage unresolved.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Available from the versioned `data-v0.2.0` GitHub data release.
Downloads are verified by file size and SHA-256 and cached for offline
reuse.
