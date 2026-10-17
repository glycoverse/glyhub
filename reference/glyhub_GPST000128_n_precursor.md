# Red-blood-cell N-glycan precursor quantification

Complete public Panorama precursor-by-sample TotalArea export; all
source precursors including explicitly marked glucose QC/normalization
standards retained.

## Usage

``` r
glyhub_GPST000128_n_precursor(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 128 features and 6 observations. The abundance assay is in
peak_area. rowData has no glycan_structure column because no feature has
a supported structural annotation.

## Source

GlycoPOST GPST000128. Panorama PrecursorChromInfo. Study:
<https://doi.org/10.1182/bloodadvances.2020003376>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000128>. Quantitative source:
<https://panoramaweb.org/Panorama%20Public/2020/U%20of%20Nebraska%20Medical%20Center%20Gundry%20Lab%20-%20Sickle%20Cell%20Manuscript/query-selectRows.api?schemaName=targetedms&query.queryName=PrecursorChromInfo&query.maxRows=2000>.

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

Six source sample identifiers 07,08,13,39,55,56 retained. Clinical group
mapping not verified, group=NA. Multiple precursors per glycan remain
separate by source precursor ID; no arbitrary charge merging. This is an
already integrated processed quantity export, no raw-MS reprocessing.

Molecular annotations retain source precision. Unresolved compositions
or structures are NA; original annotations are retained in rowData. All
quantitative source features are preserved.

## Access

Use `glyhub_load("glyhub_GPST000128_n_precursor")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
