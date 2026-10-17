
<!-- README.md is generated from README.Rmd. Please edit that file -->

# glyhub <img src="man/figures/logo.png" align="right" height="138" alt="glyhub logo" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

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
`glyhub_catalog()` for the complete catalog. N/O classes remain
separate; source experiments, sample conditions and replicate labels
remain in `colData`. Feature unions use documented author keys or
supported structures, with an explicit source-coverage mask for
unmeasured combinations.

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
# install.packages("pak")
pak::pkg_install("glycoverse/glyhub")
```

## Example

``` r
x <- glyhub::glyhub_load("glyhub_GPST000738_N_B4GalT1")
dim(x)
data.frame(as.list(S4Vectors::metadata(x)$processing_counts))
```

All datasets use `glyhub_load()`. `SummarizedExperiment::assay(x)`
contains the curated abundance matrix;
`S4Vectors::metadata(x)$raw_abundance` preserves the unconverted values.
`rowData(x)` retains typed glyrepr annotations and source evidence, and
`colData(x)` retains source conditions and observation locations.

## Loading external data

All 83 datasets are stored in the [Glyhub data
release](https://github.com/glycoverse/glyhub/releases/tag/v0.1.0). The
package includes the catalog and loader code, with no bundled data
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

**Breaking interface change:** all former dataset objects are now
functions. Add `()` when using a dataset name directly, or pass its name
to `glyhub_load()`. LazyData, variable-style access and `data()` access
are no longer provided. `glyhub_catalog()` lists all curated datasets;
`kind = "raw"` lists available source archives, currently the eight
CPTAC archives. Dataset help topics retain scientific details and source
references.

Every resource is checked against its size and SHA-256 before use. The
first call requires an internet connection; subsequent calls reuse the
cache. Set `cache_dir` or option `glyhub.cache_dir` to select its
location. `refresh = TRUE` retrieves the pinned version again;
`offline = TRUE` prohibits downloads and requires a valid cached file.
Delete cached files to clear the cache.

## CPTAC measurement conventions

Eight JHU GENCODEv34 N-glycoform-peptide matrices are available: CCRCC,
COAD, HGSC, HNSCC, LSCC, LUAD, PDAC and UCEC. The assay contains
**linearized abundance (`2^source log2 value`)**.
`metadata(x)$raw_abundance` preserves the source log2 matrix, including
zeros; `None` becomes `NA`. No features or measurement columns are
dropped. Reference, QC and unresolved sample roles remain in `colData`.
Protein accessions and absolute sites are unavailable and remain `NA`;
source peptide, gene and composition labels remain in `rowData`.
Measurement columns must not all be interpreted as independent patients.

Five supplied files match upstream MD5 checksums exactly. COAD and PDAC
match CRC and PDA after reversing column-prefix renaming. HGSC remains
unmatched to the supplied upstream checksum list, and its fractionation
identity is unverified. These limitations are recorded in the object
provenance.

Source: [CPTAC Pan-Cancer](https://pdc.cancer.gov/pdc/cptac-pancancer).
Follow [PDC data-use and attribution
guidelines](https://pdc.cancer.gov/pdc/data-use-guidelines); the
package’s MIT code license does not license source data.
