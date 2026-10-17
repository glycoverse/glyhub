# Major human schistosome species express different glycans with immunological and diagnostic implications

Annotated Schistosoma haematobium O-glycan MALDI-TOF-MS peak-intensity
records from Supplementary Data 1, sheet (E) Sh O-glycans; 122
source-specific peak records across 4 spectra.

## Usage

``` r
glyhub_GPST000602_Sh_O(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 122 features and 4 observations. The abundance assay is in
MALDI-TOF-MS peak intensity (source instrument units; arbitrary units).
rowData has no glycan_structure column because no feature has a
supported structural annotation.

## Source

GlycoPOST GPST000602. Supplementary Data 1 / Table S1 - Raw MALDI-TOF-MS
data. Study: <https://doi.org/10.1038/s41467-026-70850-0>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000602>. Quantitative source:
<https://media.springernature.com/original/springer-static/esm/art%3A10.1038%2Fs41467-026-70850-0/MediaObjects/41467_2026_70850_MOESM3_ESM.xlsx>.

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

Each retained source peak is a separate feature identified by sheet,
spectrum block and row. The sparse matrix organizes spectrum-specific
measurements without asserting cross-spectrum molecular identity.
Off-spectrum entries have source_coverage=FALSE and are not measured
missing values or biological absence. The object scope is one object per
source worksheet across the five source worksheets. This object is not a
ready-to-use cross-sample aligned feature matrix; cross-spectrum
comparisons require an independently justified feature alignment. Only
rows with a non-null author composition annotation are retained. Raw
workbook bytes and complete retained/dropped cell-level ledgers preserve
source evidence. No averaging, summation, normalization, imputation,
mass filtering, peak selection by intensity, or raw-MS processing is
performed. All retained numeric assay zeros become NA; nonzero values
are unchanged. Putative compositions do not establish exact structures
or distinguish isomers. AA and redEnd labels are stored separately from
monosaccharide counts.

All retained features have source putative composition annotations
parsed to typed monosaccharide counts; exact glycan structures remain
NA. Original labels, m/z values, all source block values and source
formulas are preserved.

## Access

Use `glyhub_load("glyhub_GPST000602_Sh_O")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
