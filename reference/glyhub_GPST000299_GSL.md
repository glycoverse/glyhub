# Onchocerca volvulus adult-female GSL glycan profile

A complete published MALDI peak-area profile from adult female
Onchocerca volvulus, used to investigate shared antigenic glycans across
filarial nematodes.

## Usage

``` r
glyhub_GPST000299_GSL(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 41 features and 1 observations. The abundance assay is in
unnormalized MALDI peak area. rowData includes a typed glycan_structure
column; features without a supported structure are NA.

## Source

GlycoPOST GPST000299. GSL glycans. Study:
<https://doi.org/10.3389/fimmu.2023.1102344>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000299>.

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

Table S4 supplies one profile per glycan class without
biological-replicate columns. All measured peaks with numerical areas
are retained, including unassigned peaks with missing molecular
annotation. Areas are preserved without normalization and cannot support
replicate-based statistical inference. Same-row SNFG topology is
transcribed where unambiguous; unspecified glycosidic bonds and
phosphocholine positions remain unknown. Ambiguous antenna attachment,
alternative isomers or missing modification placement are retained in
the source workbook rather than resolved by assumption. Analytical 2-AA
is excluded from the native glycan annotation and recorded separately.

Source-derived compositions and original labels are retained. 18
source-supported structures are typed; unspecified bonds remain unknown.
Unresolved or conflicting structures remain missing with source
provenance.

## Access

Use `glyhub_load("glyhub_GPST000299_GSL")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
