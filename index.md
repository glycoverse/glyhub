# glyhub

glyhub collects glycomics and glycoproteomics data for the Glycoverse
ecosystem, using the
[`GlycomicSE`](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
and
[`GlycoproteomicSE`](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
containers from [glyexp](https://github.com/glycoverse/glyexp). The
package is experimental.

## Available data

34 datasets from 17 public GlycoPOST projects are bundled, including
released glycans, glycosaminoglycan disaccharides and
site/charge-resolved glycopeptides. Objects combine source-defined
quantitative tables from the same study and glycan class where
measurement definitions are compatible. GPST000602 is explicitly an
annotated-peak subset with spectrum-specific, unaligned feature
identities. Inclusion does not imply recovery of every experiment in its
paper.

| Dataset | Features × observations |
|----|----|
| `glyhub_GPST000738_N_B4GalT1` | 9 × 18 |
| `glyhub_GPST000738_N_ST6GAL1` | 10 × 28 |
| `glyhub_GPST000643_O` | 365 × 71 |
| `glyhub_GPST000643_N` | 3 × 23 |
| `glyhub_GPST000213_N` | 679 × 86 |
| `glyhub_GPST000213_O` | 148 × 39 |
| `glyhub_GPST000271_N_CAL51` | 69 × 15 |
| `glyhub_GPST000271_O_CAL51` | 7 × 15 |
| `glyhub_GPST000533_N_Released` | 13 × 9 |
| `glyhub_GPST000533_N_Glycopeptides` | 54 × 9 |
| `glyhub_GPST000120_O_Spike_ACE2` | 16 × 2 |
| `glyhub_GPST000035_O` | 231 × 66 |
| `glyhub_GPST000128_n_precursor` | 128 × 6 |
| `glyhub_GPST000128_o_precursor` | 35 × 6 |
| `glyhub_GPST000183_n` | 101 × 7 |
| `glyhub_GPST000183_o` | 21 × 20 |
| `glyhub_GPST000599_serum_n` | 45 × 134 |
| `glyhub_GPST000431_N` | 70 × 62 |
| `glyhub_GPST000374_sssmug_gsl` | 13 × 10 |
| `glyhub_GPST000374_sssmug_n` | 218 × 10 |
| `glyhub_GPST000374_O` | 15 × 7 |
| `glyhub_GPST000676_GAG` | 8 × 15 |
| `glyhub_GPST000381_N_Prosaposin` | 36 × 2 |
| `glyhub_GPST000602_Sh_GSL` | 566 × 11 |
| `glyhub_GPST000602_Sm_GSL` | 183 × 3 |
| `glyhub_GPST000602_Sh_N` | 489 × 10 |
| `glyhub_GPST000602_Sm_N` | 247 × 4 |
| `glyhub_GPST000602_Sh_O` | 122 × 4 |
| `glyhub_GPST000578_N_total_peak_area` | 75 × 27 |
| `glyhub_GPST000578_N_source_repeatability_intensity` | 41 × 12 |
| `glyhub_GPST000578_N_Fetuin_TwoSites` | 14 × 2 |
| `glyhub_GPST000125_N_HEK293` | 41 × 16 |
| `glyhub_GPST000125_O_HEK293` | 14 × 16 |
| `glyhub_GPST000125_GSL_HEK293` | 12 × 16 |

Each dataset has its own help page describing the biological system,
experimental design, units, source table and limitations. Use
`data(package = "glyhub")` for the installed catalog. N/O classes remain
separate; source experiments, sample conditions and replicate labels
remain in `colData`. Feature unions use documented author keys or
supported structures, with an explicit source-coverage mask for
unmeasured combinations. The two GPST000738 enzyme assays remain
separate because their normalization reference sets differ. GPST000578
retains three measurement groups because total peak area, source
repeatability intensity and inter-instrument peak area cannot be assumed
to have identical measurement definitions. Former names are listed in
the [migration
map](https://glycoverse.github.io/glyhub/data-raw/panel-name-mapping.csv).

**Zero-valued abundances are stored as NA in the distributed assays.**
Original values, source-missing values and conflict masks remain in
metadata. No imputation or renormalization is applied. Unknown molecular
annotations remain NA without removing quantitative rows, except for the
documented annotated-only peak subset in GPST000602; its excluded source
rows remain in the provenance ledger. Structures are encoded only from
explicit source structural evidence; unresolved bonds and attachment
positions remain uncertain.

Notable limits include source-column conflicts in GPST000213, source
annotation conflicts in GPST000035, and uncertain positional assignments
in several datasets. Charge-state features in GPST000533 are not
independent biological replicates. Original source licenses and
repository terms are recorded separately from the package’s code
license. See the [curation
audit](https://glycoverse.github.io/glyhub/data-raw/AUDIT.md),
[20-project
review](https://glycoverse.github.io/glyhub/data-raw/CALIBRATION.md),
and [object
inventory](https://glycoverse.github.io/glyhub/data-raw/object-inventory.csv).

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

## Reproduction

Original inputs and scripts are grouped by accession under
`data-raw/GPST000643/` and `data-raw/GPST000738/`. From the package
root:

``` r

source("data-raw/build.R")
# Check that rebuilding preserves scientific contents:
source("data-raw/validate-reproduction.R")
```

See [validation
results](https://glycoverse.github.io/glyhub/data-raw/VALIDATION.md).
See
[`?glyhub_data_conventions`](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for shared measurement and annotation conventions.
