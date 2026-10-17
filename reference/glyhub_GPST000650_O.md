# Whole-brain O-glycans in Slc35a3-deficient mice

O-glycan amounts in whole-brain tissue from wild-type, heterozygous and
Slc 35 a 3-knockout mice, with three source observations per genotype.

## Usage

``` r
glyhub_GPST000650_O(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 25 features and 9 observations. The abundance assay is in pmol per
100 micrograms protein. rowData has no glycan_structure column because
no feature has a supported structural annotation.

## Source

GlycoPOST GPST000650. Supplementary Table 2. Study:
<https://doi.org/10.3390/ijms27041643>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000650>.

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

The source study profiles nucleotide-sugar transporter deficiency using
MALDI-TOF MS. Twenty-five annotated features are retained, including
source-undetected rows. Sialic-acid linkage labels remain in row
annotations; the paper describes composition-based assignments and does
not resolve all isomeric structures. Quantitative zeros are represented
as missing values, with original measurements and masks retained.

Source-derived composition annotations; linkage information is retained
as source annotation without inferring a full topology. No complete
unambiguous structures are asserted.

## Access

Use `glyhub_load("glyhub_GPST000650_O")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
