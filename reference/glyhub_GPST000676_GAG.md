# Sulfatase modifying factors control the timing of zebrafish convergence and extension morphogenesis. and related study experiments

Complete eight-component targeted heparan-sulfate disaccharide assay at
80% epiboly. Each sample is independent clutch of 100 embryos. Source
Data genotype replicate counts exceed GlycoPOST metadata, so source
column IDs are retained and no raw-file correspondence is asserted.
Combined GAG-glycan quantitative profiles from GPST000676. 8 union
features and 15 source observations are represented.

## Usage

``` r
glyhub_GPST000676_GAG(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 8 features and 15 observations. The abundance assay is in percent
total HS disaccharides. rowData has no glycan_structure column because
no feature has a supported structural annotation.

## Source

GlycoPOST GPST000676. Figure 5 e,f. Study:
<https://doi.org/10.1038/s41467-026-70804-6>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000676>. Quantitative source:
<https://media.springernature.com/full/springer-static/esm/art%3A10.1038%2Fs41467-026-70804-6/MediaObjects/41467_2026_70804_MOESM10_ESM.xlsx>.

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
combinations from measured missing values. Units: percent total HS
disaccharides.

Sulfatase modifying factors control the timing of zebrafish convergence
and extension morphogenesis.: Complete eight-component targeted
heparan-sulfate disaccharide assay at 80% epiboly. Each sample is
independent clutch of 100 embryos. Source Data genotype replicate counts
exceed GlycoPOST metadata, so source column IDs are retained and no
raw-file correspondence is asserted.

Sulfatase modifying factors control the timing of zebrafish convergence
and extension morphogenesis.: Complete eight-component targeted
heparan-sulfate disaccharide assay at 80% epiboly. Each sample is
independent clutch of 100 embryos. Source Data genotype replicate counts
exceed GlycoPOST metadata, so source column IDs are retained and no
raw-file correspondence is asserted.

Molecular annotations retain source precision. Unresolved compositions
or structures are NA; original annotations are retained in rowData. All
quantitative source features are preserved.

## Access

Use `glyhub_load("glyhub_GPST000676_GAG")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
