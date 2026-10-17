# Colorectal-cancer cell-line glycosphingolipid glycans

Relative glycosphingolipid-glycan abundances across 22 human
colorectal-cancer cell lines spanning unassigned, undifferentiated and
colon-like transcriptional subtypes.

## Usage

``` r
glyhub_GPST000239_GSL(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 94 features and 22 observations. The abundance assay is in relative
abundance (%). rowData includes a typed glycan_structure column;
features without a supported structure are NA.

## Source

GlycoPOST GPST000239. S-5. Study:
<https://doi.org/10.1016/j.mcpro.2022.100239>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000239>.

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

Supplementary Table S5 supplies 94 chromatographically distinguished
glycan features and cell-line aggregate abundance values. Cell-line
origin, tumour stage, differentiation and microsatellite status are
joined from Table S1 when the source identifier matches exactly.
Original antigen, glycan-family and linkage annotations are retained.
Typed structures are transcribed from the same-row SNFG diagrams with
all unspecified linkages left unknown; repeated compositions remain
separate isomer features. Values are cell-line summaries, not individual
biological-replicate measurements.

Source-derived compositions and original labels are retained. 94
source-supported structures are typed; unspecified bonds remain unknown.
Unresolved or conflicting structures remain missing with source
provenance.

## Access

Use `glyhub_load("glyhub_GPST000239_GSL")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
