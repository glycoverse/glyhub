# Pancreatic ductal adenocarcinoma: CPTAC N-glycoproteome

Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
abundance matrix as a
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html).
Downloads are cached.

## Usage

``` r
glyhub_CPTAC_PDAC(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Source

<https://pdc.cancer.gov/pdc/cptac-pancancer> Data use and attribution:
<https://pdc.cancer.gov/pdc/data-use-guidelines>. The source data are
not licensed under the package's MIT code license.

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

The assay is `2^source_value`, a linearized normalized abundance. Source
log2 values, including zeros, are retained in
`metadata(x)$raw_abundance`. Source `None` entries become `NA`; no
filtering, imputation, aggregation or further normalization is
performed. These data are an exception to the zero-to-NA convention used
for GlycoPOST datasets.

Reference and QC columns remain present, with source-label-derived roles
in `colData`. Unresolved roles remain unresolved. Repeated measurements
are not independent patients. `Intensity.Reference` is retained in
`rowData(x)$intensity_reference_log2`, not treated as a sample. Source
peptide, gene and composition annotations are retained. N/H/F/S/G
denotes HexNAc/Hex/Fuc/Neu5Ac/Neu5Gc. No structures are inferred.
Protein accessions and absolute sites are unknown (`NA`); source gene
annotations must not be treated as protein accessions.

Provenance records the supplied file hash and upstream checksum status.
COAD and PDAC match upstream CRC and PDA after reversing column-prefix
renaming; HGSC has not been matched to the supplied upstream MD5 list.
The HGSC fractionation identity therefore remains unverified. See
[`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md)
for dimensions, sizes and download URLs.

## Access

Use `glyhub_load("glyhub_CPTAC_PDAC")` to load this dataset.

## See also

[`glyhub_load()`](https://glycoverse.github.io/glyhub/reference/glyhub_load.md)
to retrieve the original TSV archive.
