# glyhub

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

**Zero-valued abundances are stored as NA in the distributed assays.**
Original values, source-missing values and conflict masks remain in
metadata. No imputation or renormalization is applied. Unknown molecular
annotations remain NA without removing quantitative rows. Structures are
encoded only from explicit source structural evidence. Unresolved bonds
and attachment positions remain uncertain.

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
