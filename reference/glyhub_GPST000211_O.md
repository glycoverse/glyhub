# O-glycans released by thrombin-activated human platelets

Released O-glycan peak areas from platelet releasates of five human
donors following thrombin stimulation.

## Usage

``` r
glyhub_GPST000211_O(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 11 features and 5 observations. The abundance assay is in peak
area. rowData includes a typed glycan_structure column; features without
a supported structure are NA.

## Source

GlycoPOST GPST000211. Table S3. Study:
<https://doi.org/10.1016/j.mcpro.2024.100717>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000211>.

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

The published total-AUC columns combine the author-measured charge
states for each of eleven glycan features. Isomer-resolved features
remain distinct. Glycans below 300 Da were outside the reported
detection range. Proposed source structures and their known linkages are
retained where explicitly represented; the trisialylated feature has
unresolved sialic-acid attachment topology and retains composition-level
annotation.

Source composition counts and proposed structures cross-checked against
the source table images and deposited GlycoWorkbench workspace;
unresolved topology remains missing.

## Access

Use `glyhub_load("glyhub_GPST000211_O")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
