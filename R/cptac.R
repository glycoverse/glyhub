#' Clear cell renal cell carcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for GlycoPOST datasets.
#'
#' Reference and QC columns remain present, with source-label-derived roles
#' in `colData`. Unresolved roles remain unresolved. Repeated measurements
#' are not independent patients. `Intensity.Reference` is retained in
#' `rowData(x)$intensity_reference_log2`, not treated as a sample.
#' Source peptide, gene and composition annotations are retained. N/H/F/S/G
#' denotes HexNAc/Hex/Fuc/Neu5Ac/Neu5Gc. No structures are inferred.
#' Protein accessions and absolute sites are unknown (`NA`); source gene
#' annotations must not be treated as protein accessions.
#'
#' Provenance records the supplied file hash and upstream checksum status.
#' COAD and PDAC match upstream CRC and PDA after reversing column-prefix
#' renaming; HGSC has not been matched to the supplied upstream MD5 list.
#' The HGSC fractionation identity therefore remains unverified.
#' See [glyhub_catalog()] for dimensions, sizes and download URLs.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_load()] to retrieve the original TSV archive.
#' @name glyhub_CPTAC_CCRCC
#' @section Access:
#' Use `glyhub_load("glyhub_CPTAC_CCRCC")` to load this dataset.
#' @inheritParams glyhub_load
#' @export
glyhub_CPTAC_CCRCC <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_CPTAC_CCRCC", kind, cache_dir, refresh, offline)
}

#' Colon adenocarcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for GlycoPOST datasets.
#'
#' Reference and QC columns remain present, with source-label-derived roles
#' in `colData`. Unresolved roles remain unresolved. Repeated measurements
#' are not independent patients. `Intensity.Reference` is retained in
#' `rowData(x)$intensity_reference_log2`, not treated as a sample.
#' Source peptide, gene and composition annotations are retained. N/H/F/S/G
#' denotes HexNAc/Hex/Fuc/Neu5Ac/Neu5Gc. No structures are inferred.
#' Protein accessions and absolute sites are unknown (`NA`); source gene
#' annotations must not be treated as protein accessions.
#'
#' Provenance records the supplied file hash and upstream checksum status.
#' COAD and PDAC match upstream CRC and PDA after reversing column-prefix
#' renaming; HGSC has not been matched to the supplied upstream MD5 list.
#' The HGSC fractionation identity therefore remains unverified.
#' See [glyhub_catalog()] for dimensions, sizes and download URLs.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_load()] to retrieve the original TSV archive.
#' @name glyhub_CPTAC_COAD
#' @section Access:
#' Use `glyhub_load("glyhub_CPTAC_COAD")` to load this dataset.
#' @inheritParams glyhub_load
#' @export
glyhub_CPTAC_COAD <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_CPTAC_COAD", kind, cache_dir, refresh, offline)
}

#' High-grade serous ovarian carcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for GlycoPOST datasets.
#'
#' Reference and QC columns remain present, with source-label-derived roles
#' in `colData`. Unresolved roles remain unresolved. Repeated measurements
#' are not independent patients. `Intensity.Reference` is retained in
#' `rowData(x)$intensity_reference_log2`, not treated as a sample.
#' Source peptide, gene and composition annotations are retained. N/H/F/S/G
#' denotes HexNAc/Hex/Fuc/Neu5Ac/Neu5Gc. No structures are inferred.
#' Protein accessions and absolute sites are unknown (`NA`); source gene
#' annotations must not be treated as protein accessions.
#'
#' Provenance records the supplied file hash and upstream checksum status.
#' COAD and PDAC match upstream CRC and PDA after reversing column-prefix
#' renaming; HGSC has not been matched to the supplied upstream MD5 list.
#' The HGSC fractionation identity therefore remains unverified.
#' See [glyhub_catalog()] for dimensions, sizes and download URLs.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_load()] to retrieve the original TSV archive.
#' @name glyhub_CPTAC_HGSC
#' @section Access:
#' Use `glyhub_load("glyhub_CPTAC_HGSC")` to load this dataset.
#' @inheritParams glyhub_load
#' @export
glyhub_CPTAC_HGSC <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_CPTAC_HGSC", kind, cache_dir, refresh, offline)
}

#' Head and neck squamous cell carcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for GlycoPOST datasets.
#'
#' Reference and QC columns remain present, with source-label-derived roles
#' in `colData`. Unresolved roles remain unresolved. Repeated measurements
#' are not independent patients. `Intensity.Reference` is retained in
#' `rowData(x)$intensity_reference_log2`, not treated as a sample.
#' Source peptide, gene and composition annotations are retained. N/H/F/S/G
#' denotes HexNAc/Hex/Fuc/Neu5Ac/Neu5Gc. No structures are inferred.
#' Protein accessions and absolute sites are unknown (`NA`); source gene
#' annotations must not be treated as protein accessions.
#'
#' Provenance records the supplied file hash and upstream checksum status.
#' COAD and PDAC match upstream CRC and PDA after reversing column-prefix
#' renaming; HGSC has not been matched to the supplied upstream MD5 list.
#' The HGSC fractionation identity therefore remains unverified.
#' See [glyhub_catalog()] for dimensions, sizes and download URLs.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_load()] to retrieve the original TSV archive.
#' @name glyhub_CPTAC_HNSCC
#' @section Access:
#' Use `glyhub_load("glyhub_CPTAC_HNSCC")` to load this dataset.
#' @inheritParams glyhub_load
#' @export
glyhub_CPTAC_HNSCC <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_CPTAC_HNSCC", kind, cache_dir, refresh, offline)
}

#' Lung squamous cell carcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for GlycoPOST datasets.
#'
#' Reference and QC columns remain present, with source-label-derived roles
#' in `colData`. Unresolved roles remain unresolved. Repeated measurements
#' are not independent patients. `Intensity.Reference` is retained in
#' `rowData(x)$intensity_reference_log2`, not treated as a sample.
#' Source peptide, gene and composition annotations are retained. N/H/F/S/G
#' denotes HexNAc/Hex/Fuc/Neu5Ac/Neu5Gc. No structures are inferred.
#' Protein accessions and absolute sites are unknown (`NA`); source gene
#' annotations must not be treated as protein accessions.
#'
#' Provenance records the supplied file hash and upstream checksum status.
#' COAD and PDAC match upstream CRC and PDA after reversing column-prefix
#' renaming; HGSC has not been matched to the supplied upstream MD5 list.
#' The HGSC fractionation identity therefore remains unverified.
#' See [glyhub_catalog()] for dimensions, sizes and download URLs.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_load()] to retrieve the original TSV archive.
#' @name glyhub_CPTAC_LSCC
#' @section Access:
#' Use `glyhub_load("glyhub_CPTAC_LSCC")` to load this dataset.
#' @inheritParams glyhub_load
#' @export
glyhub_CPTAC_LSCC <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_CPTAC_LSCC", kind, cache_dir, refresh, offline)
}

#' Lung adenocarcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for GlycoPOST datasets.
#'
#' Reference and QC columns remain present, with source-label-derived roles
#' in `colData`. Unresolved roles remain unresolved. Repeated measurements
#' are not independent patients. `Intensity.Reference` is retained in
#' `rowData(x)$intensity_reference_log2`, not treated as a sample.
#' Source peptide, gene and composition annotations are retained. N/H/F/S/G
#' denotes HexNAc/Hex/Fuc/Neu5Ac/Neu5Gc. No structures are inferred.
#' Protein accessions and absolute sites are unknown (`NA`); source gene
#' annotations must not be treated as protein accessions.
#'
#' Provenance records the supplied file hash and upstream checksum status.
#' COAD and PDAC match upstream CRC and PDA after reversing column-prefix
#' renaming; HGSC has not been matched to the supplied upstream MD5 list.
#' The HGSC fractionation identity therefore remains unverified.
#' See [glyhub_catalog()] for dimensions, sizes and download URLs.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_load()] to retrieve the original TSV archive.
#' @name glyhub_CPTAC_LUAD
#' @section Access:
#' Use `glyhub_load("glyhub_CPTAC_LUAD")` to load this dataset.
#' @inheritParams glyhub_load
#' @export
glyhub_CPTAC_LUAD <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_CPTAC_LUAD", kind, cache_dir, refresh, offline)
}

#' Pancreatic ductal adenocarcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for GlycoPOST datasets.
#'
#' Reference and QC columns remain present, with source-label-derived roles
#' in `colData`. Unresolved roles remain unresolved. Repeated measurements
#' are not independent patients. `Intensity.Reference` is retained in
#' `rowData(x)$intensity_reference_log2`, not treated as a sample.
#' Source peptide, gene and composition annotations are retained. N/H/F/S/G
#' denotes HexNAc/Hex/Fuc/Neu5Ac/Neu5Gc. No structures are inferred.
#' Protein accessions and absolute sites are unknown (`NA`); source gene
#' annotations must not be treated as protein accessions.
#'
#' Provenance records the supplied file hash and upstream checksum status.
#' COAD and PDAC match upstream CRC and PDA after reversing column-prefix
#' renaming; HGSC has not been matched to the supplied upstream MD5 list.
#' The HGSC fractionation identity therefore remains unverified.
#' See [glyhub_catalog()] for dimensions, sizes and download URLs.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_load()] to retrieve the original TSV archive.
#' @name glyhub_CPTAC_PDAC
#' @section Access:
#' Use `glyhub_load("glyhub_CPTAC_PDAC")` to load this dataset.
#' @inheritParams glyhub_load
#' @export
glyhub_CPTAC_PDAC <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_CPTAC_PDAC", kind, cache_dir, refresh, offline)
}

#' Uterine corpus endometrial carcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for GlycoPOST datasets.
#'
#' Reference and QC columns remain present, with source-label-derived roles
#' in `colData`. Unresolved roles remain unresolved. Repeated measurements
#' are not independent patients. `Intensity.Reference` is retained in
#' `rowData(x)$intensity_reference_log2`, not treated as a sample.
#' Source peptide, gene and composition annotations are retained. N/H/F/S/G
#' denotes HexNAc/Hex/Fuc/Neu5Ac/Neu5Gc. No structures are inferred.
#' Protein accessions and absolute sites are unknown (`NA`); source gene
#' annotations must not be treated as protein accessions.
#'
#' Provenance records the supplied file hash and upstream checksum status.
#' COAD and PDAC match upstream CRC and PDA after reversing column-prefix
#' renaming; HGSC has not been matched to the supplied upstream MD5 list.
#' The HGSC fractionation identity therefore remains unverified.
#' See [glyhub_catalog()] for dimensions, sizes and download URLs.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_load()] to retrieve the original TSV archive.
#' @name glyhub_CPTAC_UCEC
#' @section Access:
#' Use `glyhub_load("glyhub_CPTAC_UCEC")` to load this dataset.
#' @inheritParams glyhub_load
#' @export
glyhub_CPTAC_UCEC <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_CPTAC_UCEC", kind, cache_dir, refresh, offline)
}
