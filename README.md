
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

75 datasets from 47 public GlycoPOST projects are bundled, including
released glycans, glycosaminoglycan disaccharides and
site/charge-resolved glycopeptides. Objects combine source-defined
quantitative tables from the same study and glycan class where
measurement definitions are compatible. GPST000602 is explicitly an
annotated-peak subset with spectrum-specific, unaligned feature
identities. Inclusion does not imply recovery of every experiment in its
paper.

Each dataset has its own help page describing the biological system,
experimental design, units, source table and limitations. Use
`data(package = "glyhub")` for the installed catalog. N/O classes remain
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
x <- glyhub::glyhub_GPST000738_N_B4GalT1
dim(x)
#> [1]  9 18
data.frame(as.list(S4Vectors::metadata(x)$processing_counts))
#>   source_missing source_nd conflict zero_to_na
#> 1              0         0       24          6
```

Data use R’s LazyData mechanism. `SummarizedExperiment::assay(x)`
contains the curated abundance matrix;
`S4Vectors::metadata(x)$raw_abundance` preserves the unconverted values.
`rowData(x)` retains typed glyrepr annotations and source evidence, and
`colData(x)` retains source conditions and observation locations.

## CPTAC glycoproteomes

Eight JHU GENCODEv34 N-glycoform-peptide matrices are available through
`glyhub_CPTAC_CCRCC()`, `glyhub_CPTAC_COAD()`, `glyhub_CPTAC_HGSC()`,
`glyhub_CPTAC_HNSCC()`, `glyhub_CPTAC_LSCC()`, `glyhub_CPTAC_LUAD()`,
`glyhub_CPTAC_PDAC()` and `glyhub_CPTAC_UCEC()`. These are loader
functions, rather than the LazyData objects listed above.

``` r
glyhub::glyhub_cptac_catalog()[, c("dataset", "kind", "storage", "bytes")]
#>               dataset    kind storage    bytes
#> 1  glyhub_CPTAC_CCRCC curated release 47437468
#> 2  glyhub_CPTAC_CCRCC     raw release 21401950
#> 3   glyhub_CPTAC_COAD curated release  5653760
#> 4   glyhub_CPTAC_COAD     raw release  2683719
#> 5   glyhub_CPTAC_HGSC curated release  2501440
#> 6   glyhub_CPTAC_HGSC     raw release  1187065
#> 7  glyhub_CPTAC_HNSCC curated release 19378376
#> 8  glyhub_CPTAC_HNSCC     raw release  8966305
#> 9   glyhub_CPTAC_LSCC curated release 22958288
#> 10  glyhub_CPTAC_LSCC     raw release 10591675
#> 11  glyhub_CPTAC_LUAD curated release 27852408
#> 12  glyhub_CPTAC_LUAD     raw release 12734529
#> 13  glyhub_CPTAC_PDAC curated release 36204104
#> 14  glyhub_CPTAC_PDAC     raw release 16438827
#> 15  glyhub_CPTAC_UCEC curated release  4556352
#> 16  glyhub_CPTAC_UCEC     raw release  2288060
```

``` r
x <- glyhub::glyhub_CPTAC_CCRCC() # Download once, then use the verified cache
x <- glyhub::glyhub_CPTAC_CCRCC(offline = TRUE)
raw_file <- glyhub::glyhub_cptac_download("CCRCC", kind = "raw")
```

Curated files up to 2 MiB (xz-compressed RDS) are bundled; larger
datasets are downloaded on demand. Raw TSV gzip archives and all curated
RDS files are preserved in the [versioned data
release](https://github.com/glycoverse/glyhub/releases/tag/cptac-data-v1).
No large source files are tracked by Git. Downloads are checked against
the package’s SHA-256 manifest. `cache_dir` or option `glyhub.cache_dir`
selects the cache; `refresh = TRUE` downloads a fresh copy. An offline
call requires a valid cached or bundled file. Remove downloaded files to
clear the cache.

The assay contains **linearized abundance (`2^source log2 value`)**.
`metadata(x)$raw_abundance` preserves the source log2 matrix, including
zeros; `None` is represented as `NA`. No features or measurement columns
are dropped. Reference, QC and unresolved sample roles remain annotated
in `colData`. Absolute protein sites and protein accessions are
unavailable and remain `NA`; source peptide, gene and glycan-composition
labels are retained in `rowData`. The matrices do not establish
independent patients for every measurement column.

Five supplied files match upstream MD5 checksums exactly. COAD and PDAC
match CRC and PDA after reversing sample-column prefix renaming. HGSC
has not been matched to the supplied upstream checksum list; its
fractionation identity remains unverified. These limitations are
recorded in each object’s provenance.

Source: [CPTAC Pan-Cancer](https://pdc.cancer.gov/pdc/cptac-pancancer).
Follow [PDC data-use and attribution
guidelines](https://pdc.cancer.gov/pdc/data-use-guidelines); the
package’s MIT code license does not license the source data.
