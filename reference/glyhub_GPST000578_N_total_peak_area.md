# Immunoglobulins N-glycan total peak areas and related study experiments

N-glycopedia applies structure-specific SRM profiling to purified human
immunoglobulins. All 35 rows of the source IgA/IgG/IgM table and nine
technical preparation/LC-MS replicate measurements are retained as raw
total peak areas; normalized abundances and statistical summaries remain
in the source workbook. Combined N-glycan quantitative profiles from
GPST000578. 75 union features and 27 source observations are
represented.

## Usage

``` r
glyhub_GPST000578_N_total_peak_area(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 75 features and 27 observations. The abundance assay is in total
peak area. rowData includes a typed glycan_structure column; features
without a supported structure are NA.

## Source

GlycoPOST GPST000578. Figure 5bc. Study:
<https://doi.org/10.1038/s41467-026-73091-3>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000578>. Quantitative source:
<https://media.springernature.com/original/springer-static/esm/art%3A10.1038%2Fs41467-026-73091-3/MediaObjects/41467_2026_73091_MOESM4_ESM.xls>.

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

Source experiments are identified in colData and original panel-specific
metadata, annotations and measurements are retained in metadata. Feature
identities are aligned only when supported by author identifiers or
explicit molecular structures; other features retain source-specific
identities. The source_coverage matrix distinguishes unmeasured
combinations from measured missing values. Units: total peak area.

Immunoglobulins N-glycan total peak areas: Entire source feature block
retained. Zero-valued abundance is to be converted to NA with original
values retained; no sample pairing inferred. GlyTouCan IDs are source
annotations; sequence/composition mapping is pending verification.
Quantitative zeros are represented as NA without imputation or
renormalization; original measurements are retained. GlyTouCan
identifiers remain the source assignments.

CHO Perturbation N-glycan total peak areas: Entire source feature block
retained. Zero-valued abundance is to be converted to NA with original
values retained; no sample pairing inferred. GlyTouCan IDs are source
annotations; sequence/composition mapping is pending verification.
Quantitative zeros are represented as NA without imputation or
renormalization; original measurements are retained. GlyTouCan
identifiers remain the source assignments.

Recombinant Spike N-glycans from SF9 and CHO expression: Complete
61-feature raw total-area block from Figure 5a. The later 9-feature SF9
and 51-feature CHO presentation blocks repeat measurements from this
block; these filtered presentations are retained as source context and
not counted as additional observations. Quantitative zeros are
represented as NA without imputation or renormalization; original
measurements are retained. GlyTouCan identifiers remain the source
assignments.

Recombinant Spike N-glycans from HEK293 expression: Complete 34-feature
HEK293 source block from Figure 5a, retaining raw total peak areas for
the three technical preparations. Source per-glycan class and summary
relative values are contextual annotations, not additional samples.
Quantitative zeros are represented as NA without imputation or
renormalization; original measurements are retained. GlyTouCan
identifiers remain the source assignments.

All source GlyTouCan identifiers resolve to WURCS through the official
GlyTouCan SPARQL service. Structures are converted with glyparse 0.8.1
and validated with glyrepr 1.1.0, and compositions are derived from the
validated structures. No mass-based assignments or new experimental
linkage evidence are inferred.

## Access

Use `glyhub_load("glyhub_GPST000578_N_total_peak_area")` to load this
dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
