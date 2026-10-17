# Platelet N-glycan isomer profiles in control and FUT8-knockout mice

Fifty N-glycan chromatographic features quantified in platelet lysates
from three control and three FUT8-knockout mouse observations,
supporting a study of platelet activation and thrombosis.

## Usage

``` r
glyhub_GPST000596_N(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 50 features and 6 observations. The abundance assay is in area
under chromatographic curve. rowData has no glycan_structure column
because no feature has a supported structural annotation.

## Source

GlycoPOST GPST000596. . Study:
<https://doi.org/10.1161/atvbaha.126.324757>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000596>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000596.0/FUT8-KO_Manuscript_SupplementaryTable_Final.xlsx>.

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

The assay contains the six original area-under-curve columns C1–C3 and
K1–K3. Isomer labels, retention times, precursor charge and mass, glycan
class and author-assigned fucosyl linkage are retained. The separate
normalized block in the source workbook contains fractions despite its
percent heading; it is not duplicated as an independent dataset.
Replicate biology beyond the author condition labels is not inferred.

Explicit total Hex, HexNAc, Fuc, NeuGc and NeuAc counts are used.
Distinct chromatographic isomers remain distinct features.
Core/outer-arm linkage information is retained as an author annotation
and is not expanded into an unsupported complete glycan topology.

## Access

Use `glyhub_load("glyhub_GPST000596_N")` to load this dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
