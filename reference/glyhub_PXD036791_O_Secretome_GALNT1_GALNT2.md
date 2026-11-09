# N/TERT-1 Secretome_GALNT1_GALNT2 O-glycopeptide reporter abundance

N/TERT-1 Secretome_GALNT1_GALNT2 O-glycopeptide reporter abundance

## Usage

``` r
glyhub_PXD036791_O_Secretome_GALNT1_GALNT2(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 987 source rows and 6 measurements.

## Source

<https://doi.org/10.1038/s41467-022-33806-8>. CC BY 4.0; original-author
supplementary abundance table, no separate exclusion located

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

Author site-associated glycopeptide rows, with full source TMT6plex
measurements. A multisite peptide's signal is copied by the authors to
its constituent sites; those rows are not independent quantified sites.
Source T/Tn labels are retained. One shared GALNT1/GALNT2 secretome
experiment, with WT channels retained only once.

Source scale: Linear author-normalized TMT6plex reporter abundance;
source total-peptide-level normalization.

All original selected source numbers are retained in the assay and
`metadata(x)$raw_abundance`, including zeros and missing values. No
additional normalization, imputation or inverse transformation is
applied. No glycan structures are inferred. Consult metadata for
provenance, source row/column coordinates, attribution and limitations.

## Availability

Available from the versioned `data-v0.2.0` GitHub data release.
Downloads are verified by file size and SHA-256 and cached for offline
reuse.
