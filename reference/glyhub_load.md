# Load any glyhub dataset

Load any dataset from the shared external data release. Dataset
identifiers also name convenience functions that call this loader with
the same options.

## Usage

``` r
glyhub_load(
  dataset,
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Arguments

- dataset:

  Exact dataset identifier from
  [`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md),
  for example `"glyhub_GPST000738_N_B4GalT1"` or `"glyhub_CPTAC_CCRCC"`.

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

## Value

For `kind = "curated"`, a
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
or
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html).
For `kind = "raw"`, an absolute file path.

## Details

Downloads and cached files are checked against the package's size and
SHA-256 manifest before use. Files are cached by version and hash.
Interrupted or invalid downloads never replace a verified cached file.
`refresh = TRUE` cannot be combined with `offline = TRUE`. Delete
downloaded files from `cache_dir` to clear the cache.

Dataset objects are no longer exposed through LazyData or
[`data()`](https://rdrr.io/r/utils/data.html). Use this loader or each
dataset's same-named function. Both return identical objects and share
the verified cache. Consult dataset help for scientific details.

## See also

[`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md),
[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)

## Examples

``` r
glyhub_catalog()[1:3, c("dataset", "bytes")]
#>                       dataset  bytes
#> 1 glyhub_GPST000738_N_B4GalT1  85324
#> 2 glyhub_GPST000738_N_ST6GAL1  86980
#> 3         glyhub_GPST000643_O 136920
```
