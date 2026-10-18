# glyhub

glyhub collects glycomics and glycoproteomics data for the Glycoverse
ecosystem, using the
[`GlycomicSE`](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
and
[`GlycoproteomicSE`](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
containers from [glyexp](https://github.com/glycoverse/glyexp). The
package is experimental.

## Available data

glyhub provides **97 curated datasets** as `GlycomicSE` or
`GlycoproteomicSE` objects:

| Source | Datasets | Coverage |
|:---|---:|:---|
| GlycoPOST | 75 | 47 public projects covering released N- and O-glycans, glycosphingolipid-derived glycans, glycosaminoglycan disaccharides and glycopeptides. |
| CPTAC | 8 | N-glycoproteomics from eight cancer cohorts: CCRCC, COAD, HGSC, HNSCC, LSCC, LUAD, PDAC and UCEC. |
| PRIDE, jPOST, iProX and MassIVE | 14 | Published N- and O-glycoproteomics studies, including a human tissue atlas, mouse brain, cancer, DQGlyco and Glyco-DIA experiments. |

Use
[`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md)
to browse dataset identifiers, experiment and glycan types, structure
availability and quantification methods. Each dataset’s help page
describes its biological system, experimental design, source tables,
units and limitations. Data are downloaded on demand from a versioned
release and cached locally; see the loading examples below.

Objects retain source feature annotations in `rowData`, measurement
conditions and observation labels in `colData`, and original numerical
values and processing records in metadata. Compatible GlycoPOST tables
from the same study and glycan class are combined using supported
feature identities, with source-coverage masks for unmeasured
combinations. Structures are encoded only when supported by explicit
evidence; unresolved annotations remain uncertain. Inclusion may cover
only part of a study: GPST000602, for example, contains annotated peaks
with spectrum-specific feature identities rather than an aligned feature
matrix.

**Abundance scales and missing-value rules depend on the source:**

- **GlycoPOST:** zero-valued abundances become `NA` in the assay.
  Original values and processing masks remain in metadata; glyhub adds
  no imputation or renormalization.
- **CPTAC:** assays contain `2^source_value`, while original log2 values
  remain in `metadata(x)$raw_abundance`. A source zero becomes 1; source
  missing values remain `NA`.
- **Other published studies:** source numerical values and zeros are
  retained, except for the documented `-1` to `NA` convention in
  `glyhub_MSV000089484_N_HCC`. Some source tables already contain
  normalization, imputation or feature selection, as documented in the
  dataset help.

Consult
[`?glyhub_data_conventions`](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
and the dataset help before comparing assays. `raw_abundance` preserves
the selected source matrix and may itself contain author-processed
values. Source-data licenses and citation requirements are recorded
separately from the package’s code license.

## Installation

The glyhub package is not a core glycoverse package. You need to install
it individually even if you have installed the meta-package
[glycoverse](https://github.com/glycoverse/glycoverse).

You can install the latest release of glyhub from
[r-universe](https://glycoverse.r-universe.dev/glyhub)
(**recommended**):

``` r

pak::repo_add(glycoverse = "https://glycoverse.r-universe.dev")
pak::pkg_install("glyhub")
```

Or from [GitHub](https://github.com/glycoverse/glyhub):

``` r

pak::pkg_install("glycoverse/glyhub@*release")
```

Or install the development version (NOT recommended):

``` r

pak::pkg_install("glycoverse/glyhub")
```

**Note:** Tips and troubleshooting for the meta-package
[glycoverse](https://github.com/glycoverse/glycoverse) are also
applicable here: [Installation of
glycoverse](https://github.com/glycoverse/glycoverse#installation).

The Glycoverse repository provides dependencies such as `glyexp`. `pak`
also resolves required Bioconductor packages for your R version.

## Example

The datasets are stored in the [Glyhub data
release](https://github.com/glycoverse/glyhub/releases/tag/data-v0.1.0).
The package includes the catalog and loader code, with no bundled data
objects.

``` r

head(glyhub::glyhub_catalog()[, c("dataset", "source", "bytes")])
#> # A tibble: 6 × 3
#>   dataset                     source     bytes
#>   <chr>                       <chr>      <int>
#> 1 glyhub_GPST000738_N_B4GalT1 GlycoPOST  85324
#> 2 glyhub_GPST000738_N_ST6GAL1 GlycoPOST  86980
#> 3 glyhub_GPST000643_O         GlycoPOST 136920
#> 4 glyhub_GPST000643_N         GlycoPOST  10320
#> 5 glyhub_GPST000213_N         GlycoPOST 273048
#> 6 glyhub_GPST000213_O         GlycoPOST  46920
```

Use either the common loader or a dataset’s own function. Both share the
same verified cache and return the same object:

``` r

x <- glyhub::glyhub_load("glyhub_CPTAC_CCRCC")
x <- glyhub::glyhub_CPTAC_CCRCC()

x <- glyhub::glyhub_GPST000738_N_B4GalT1()
x <- glyhub::glyhub_load("glyhub_GPST000738_N_B4GalT1", offline = TRUE)

# Original CPTAC source archive; returns a verified local file path.
raw_file <- glyhub::glyhub_CPTAC_CCRCC(kind = "raw")
# Equivalent: glyhub::glyhub_load("glyhub_CPTAC_CCRCC", kind = "raw")
```
