# Chondroitin/dermatan sulfate disaccharide profiles measured by HILIC-Q-TOF-MS

Lyase-derived disaccharides from commercial glycosaminoglycans, cultured
human cells, murine tissues, and human urine measured after reductive
isotopic aniline labeling.

## Usage

``` r
glyhub_GPST000604_CS_DS(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 7 features and 18 observations. The abundance assay is in summed
sample 12C XIC peak area, arbitrary units. rowData has no
glycan_structure column because no feature has a supported structural
annotation.

## Source

GlycoPOST GPST000604. ac5c02338_si_002.xlsx. Study:
<https://doi.org/10.1021/acs.analchem.5c02338>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000604>.

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

Sample 12C XIC peak areas are summed across observed sodium adducts.
Matched 13C internal-standard areas and source-cell provenance are
retained in metadata. These are unnormalized instrumental areas, not
published absolute amounts. Source zero totals are represented as
missing assay values. Source chemistry preserves the 4,5-unsaturated
uronic acid and positional sulfation assignments from Supplemental Table
S1. Typed composition and structure are missing because the current
glyrepr vocabulary does not represent the unsaturated residue; exact
source chemistry remains available in rowData.

Exact source structures and modification counts retained; typed
composition missing because DeltaUA is unsupported. No saturated-residue
substitution.

## Access

Use `glyhub_load("glyhub_GPST000604_CS_DS")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
