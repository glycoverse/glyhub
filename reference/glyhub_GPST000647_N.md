# Whole-brain N-glycans in Slc35a3-deficient mice

N-glycan amounts in whole-brain tissue from wild-type, heterozygous and
Slc 35 a 3-knockout mice, with three source observations per genotype.

## Usage

``` r
glyhub_GPST000647_N(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 179 features and 9 observations. The abundance assay is in pmol per
100 micrograms protein. rowData has no glycan_structure column because
no feature has a supported structural annotation.

## Source

GlycoPOST GPST000647. Supplementary Table 1. Study:
<https://doi.org/10.3390/ijms27041643>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000647>.

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

The 179 rows include paucimannose, high-mannose, hybrid, neutral-complex
and acidic-complex features. Paucimannose counts are literal; other
source counts describe residues beyond the Hex 3 HexNAc 2 N-glycan core.
Full compositions include this core, consistent with the reported mass
series and the paper core-plus-HexNAc convention. Source alpha 2,3/alpha
2,6 sialic-acid counts are retained as partial linkage annotations;
predicted SNFG cartoons are not promoted to experimentally resolved
isomer structures.

Source-derived composition annotations; linkage information is retained
as source annotation without inferring a full topology. No complete
unambiguous structures are asserted.

## Access

Use `glyhub_load("glyhub_GPST000647_N")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
