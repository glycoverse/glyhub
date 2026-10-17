# Ion-source dopant effects on O-glycan signal

Targeted peak areas for 15 selected O-glycan features measured in
technical injection replicates under six ion-source gas/dopant
conditions.

## Usage

``` r
glyhub_GPST000170_O(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 15 features and 18 observations. The abundance assay is in peak
area. rowData has no glycan_structure column because no feature has a
supported structural annotation.

## Source

GlycoPOST GPST000170. S1. Study:
<https://doi.org/10.1021/acs.analchem.1c00023>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000170>.

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

The panel compares AIR, nitrogen and solvent-enriched nitrogen
conditions using three injections per condition. This is the complete
author-defined 15-feature targeted panel, not an unbiased whole-glycome
survey. Isomer suffixes remain separate; Sg denotes Neu5Gc. Relative
area summaries and signal-to-noise statistics are not mistaken for extra
samples. The N-glycan sample is a 1:1 mixture released from human IgG
and bovine fetuin; the O-glycan sample derives from bovine submaxillary
mucin. Each run injected 1 microlitre.

Source molecular compositions retained without inferring glycosidic
linkages.

## Access

Use `glyhub_load("glyhub_GPST000170_O")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
