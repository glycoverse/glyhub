# N-glycan remodeling after TANGO2 loss

Relative abundances of 82 released N-glycan features in TANGO2 knockout
and control cells, with three quantitative columns per genotype.

## Usage

``` r
glyhub_GPST000473_N(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 82 features and 6 observations. The abundance assay is in relative
abundance fraction. rowData includes a typed glycan_structure column;
features without a supported structure are NA.

## Source

GlycoPOST GPST000473. Supplementary Data 3, glycomics. Study:
<https://doi.org/10.1038/s41467-025-60563-1>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000473>.

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

PGC-LC-MS profiling of PNGase F-released, reduced N-glycans examines
cellular glycosylation changes associated with TANGO2 loss and altered
cytoskeletal organization. The six individual source columns are
retained; the figure caption reports five biological replicates for a
broader panel but this table contains three per genotype. Likely source
topologies are retained with unmarked linkages and bracketed attachments
unresolved. The FA3 feature has conflicting shorthand and diagram
annotations and therefore lacks typed glycan annotations.

Likely SNFG topologies transcribed from the source diagrams; uncertain
linkages and bracketed terminal parents remain ambiguous. Source row 38
has a label/diagram conflict.

## Access

Use `glyhub_load("glyhub_GPST000473_N")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
