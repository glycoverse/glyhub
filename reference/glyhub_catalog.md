# List available glyhub datasets

List released and locally staged datasets without downloading any files.
Data assets are excluded from the package. A staged entry has no
download URL and requires the maintainer's verified local cache.

## Usage

``` r
glyhub_catalog(kind = c("curated", "raw", "all"))
```

## Arguments

- kind:

  List `"curated"` datasets (default), `"raw"` source archives, or
  `"all"` resources. Raw archives are currently available for CPTAC
  only.

## Value

A tibble containing dataset identifiers, source, file format, storage,
compressed bytes, SHA-256, version, URL and dimensions. Additional
metadata columns are:

- `exp_type`: `"glycomics"` or `"glycoproteomics"`.

- `glycan_type`: Glycan type recorded in the curated object.

- `has_glycan_structures`: Whether at least one non-missing typed glycan
  structure is available, rather than compositions alone.

- `quant_method`: Source-recorded quantification description, falling
  back to the assay scale or unit when no explicit method is recorded.
  This is descriptive text, not a controlled classification of
  instruments.

Raw archives inherit experiment and glycan types from their curated
dataset; structure availability and quantification descriptions are `NA`
for raw archives. Unavailable or outdated object metadata is also
returned as `NA`.

## Examples

``` r
glyhub_catalog()[, c("dataset", "storage", "bytes")]
#> # A tibble: 97 × 3
#>    dataset                           storage  bytes
#>    <chr>                             <chr>    <int>
#>  1 glyhub_GPST000738_N_B4GalT1       release  85324
#>  2 glyhub_GPST000738_N_ST6GAL1       release  86980
#>  3 glyhub_GPST000643_O               release 136920
#>  4 glyhub_GPST000643_N               release  10320
#>  5 glyhub_GPST000213_N               release 273048
#>  6 glyhub_GPST000213_O               release  46920
#>  7 glyhub_GPST000271_N_CAL51         release  26868
#>  8 glyhub_GPST000271_O_CAL51         release   5336
#>  9 glyhub_GPST000533_N_Released      release   9584
#> 10 glyhub_GPST000533_N_Glycopeptides release  23040
#> # ℹ 87 more rows
```
