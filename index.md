# glyhub

glyhub collects glycomics and glycoproteomics data for the Glycoverse
ecosystem, using the
[`GlycomicSE`](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
and
[`GlycoproteomicSE`](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
containers from [glyexp](https://github.com/glycoverse/glyexp). The
package is experimental.

## Available data

75 datasets from 47 public GlycoPOST projects are available, including
released glycans, glycosaminoglycan disaccharides and
site/charge-resolved glycopeptides. Objects combine source-defined
quantitative tables from the same study and glycan class where
measurement definitions are compatible. GPST000602 is explicitly an
annotated-peak subset with spectrum-specific, unaligned feature
identities. Inclusion does not imply recovery of every experiment in its
paper.

Each dataset has its own help page describing the biological system,
experimental design, units, source table and limitations. Use
[`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md)
for the complete catalog. N/O classes remain separate; source
experiments, sample conditions and replicate labels remain in `colData`.
Feature unions use documented author keys or supported structures, with
an explicit source-coverage mask for unmeasured combinations.

**For GlycoPOST datasets, zero-valued abundances are stored as NA in the
distributed assays.** Original values, source-missing values and
conflict masks remain in metadata. No imputation or renormalization is
applied. Unknown molecular annotations remain NA without removing
quantitative rows. Structures are encoded only from explicit source
structural evidence. Unresolved bonds and attachment positions remain
uncertain.

## Installation

Install the development version from
[GitHub](https://github.com/glycoverse/glyhub):

``` r

pak::repo_add(glycoverse = "https://glycoverse.r-universe.dev")
pak::pkg_install("glycoverse/glyhub")
```

The Glycoverse repository provides dependencies such as `glyexp`. `pak`
also resolves required Bioconductor packages for your R version.

## Example

The 83 existing released datasets are stored in the [Glyhub data
release](https://github.com/glycoverse/glyhub/releases/tag/data-v0.1.0).
The package includes the catalog and loader code, with no bundled data
objects.

``` r

head(glyhub::glyhub_catalog()[, c("dataset", "source", "bytes")])
#>                       dataset    source  bytes
#> 1 glyhub_GPST000738_N_B4GalT1 GlycoPOST  85324
#> 2 glyhub_GPST000738_N_ST6GAL1 GlycoPOST  86980
#> 3         glyhub_GPST000643_O GlycoPOST 136920
#> 4         glyhub_GPST000643_N GlycoPOST  10320
#> 5         glyhub_GPST000213_N GlycoPOST 273048
#> 6         glyhub_GPST000213_O GlycoPOST  46920
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
