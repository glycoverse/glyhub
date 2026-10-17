# Brugia malayi glycosphingolipid glycans across life stages

MALDI-TOF MS peak-area profiles of released glycans from mixed-sex adult
worms, microfilariae, adult females and adult males.

## Usage

``` r
glyhub_GPST000240_GSL(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 47 features and 8 observations. The abundance assay is in MALDI-TOF
MS integrated peak area (arbitrary units). rowData includes a typed
glycan_structure column; features without a supported structure are NA.

## Source

GlycoPOST GPST000240. Supplementary Table S4, B - MALDI Raw Data. Study:
<https://doi.org/10.1016/j.mcpro.2022.100201>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000240>.

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

Forty-seven source-assigned molecular features are retained, including
features without a quantified assignment in a particular spectrum.
Mixed-sex adult and microfilarial material each have an original
spectrum and two explicitly labelled biological replicates.
Sex-separated adults have one profile each. Areas are preserved on the
source instrumental scale. Unassigned or undetected features remain
missing; no zero filling or normalization is applied. Source
phosphorylcholine and glucuronic-acid composition components are
represented explicitly. Proposed structural diagrams are transcribed and
composition-checked against the same source feature rows. Unlabelled
bonds are unknown; source ambiguity braces are represented as floating
groups without selecting a particular attachment. GSL-GP34 has H2N6PC1A1
in the source composition but H2N4PC1A1 in its proposed diagram; both
typed composition and structure are missing for this feature, while the
conflicting evidence and peak areas remain available.

46 proposed source structures are encoded with unspecified linkages and
floating groups kept uncertain. Source compositions preserve Hex,
HexNAc, Fuc, GlcA and phosphorylcholine; analytical anthranilic-acid
labeling is recorded separately.

## Access

Use `glyhub_load("glyhub_GPST000240_GSL")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
