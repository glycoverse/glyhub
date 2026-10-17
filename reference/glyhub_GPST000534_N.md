# N-glycan profiles of two tardigrade species

Published relative molar abundances of N-glycans isolated from
Ramazzottius varieornatus and Hypsibius exemplaris.

## Usage

``` r
glyhub_GPST000534_N(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 25 features and 2 observations. The abundance assay is in relative
quantity mol %. rowData includes a typed glycan_structure column;
features without a supported structure are NA.

## Source

GlycoPOST GPST000534. Deposited Table.docx, N-Glycans derived from R.
varieornatus and H. exemplaris. Study:
<https://doi.org/10.1016/j.mcpro.2025.100979>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000534>.

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

The author table reports 24 identified glycan structures and an
unresolved Others fraction for two species-level profiles. PA-labeled
glycans were separated chromatographically; analytes sharing an LC peak
remain separate by observed mass, using the author-reported MALDI
intensity-based proportions. The source does not provide individual
biological replicate columns, so these profiles cannot estimate
within-species variation. Linkages explicitly drawn in the source are
preserved; the unresolved aggregate has no typed glycan annotation.

Twenty-four source linkage diagrams independently checked against the
rendered deposited table; Others retains missing composition and
structure.

## Access

Use `glyhub_load("glyhub_GPST000534_N")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
