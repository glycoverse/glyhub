# Desialylated haptoglobin glycopeptides in sepsis serum

Haptoglobin purified from healthy-control and sepsis serum was analyzed
by LC-ESI MS after desialylation. The complete six-panel source table
contains three HC0, three SG1 and three SG2 observations.

## Usage

``` r
glyhub_GPST000533_N_Glycopeptides(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 54 features and 9 observations. The abundance assay is in LC-MS
extracted-ion peak intensity. rowData includes a typed glycan_structure
column; features without a supported structure are NA.

## Source

GlycoPOST GPST000533. results of 231111_Hpt. Study:
<https://doi.org/10.1038/s41467-025-56524-3>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000533>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000533.0/Result%20file%20of%20231111_Hpt_glycopeptides%20for%20Fig%20and%20GlycoPOST.xlsx>.
Annotation evidence:
<https://media.springernature.com/original/springer-static/esm/art%3A10.1038%2Fs41467-025-56524-3/MediaObjects/41467_2025_56524_MOESM1_ESM.pdf>.

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

The source protein is UniProt P00738. All six quantitative panels in the
selected author sheet are retained: Site 3 (3+), Site 4 (4+ and 3+),
Site 2 (3+ and 2+), and oxidized Site 1 (3+). Charge states are distinct
features, not independent samples, and are not summed. All panels have
matching sample and raw-data identifiers. Source Site 1 binding position
84 conflicts with the listed peptide interval 179-194, so typed
protein_site is NA for that panel. Other site positions are retained
directly. Source intensity is the assay; author percentages are
preserved separately. No normalization, replicate pooling or
composition-from-mass reconstruction is applied. Antennarity and
fucosylation labels are source annotations. Compositions and supported
structures are transcribed from directly reviewed Supplementary Figures
1d/e and 2a; unresolved fucose positions remain structurally unassigned.

Composition counts are transcribed from the author-labelled SNFG
structures in Supplementary Figures 1d/e and 2a. Typed structures
preserve unknown linkages; terminal or otherwise unlocalized fucose is
left structurally unassigned. Original labels and figure evidence are
retained.

## Access

Use `glyhub_load("glyhub_GPST000533_N_Glycopeptides")` to load this
dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
