#' List CPTAC glycoproteome resources
#'
#' Inspect bundled and remotely hosted resources without downloading data.
#' Storage is selected per dataset using the compressed curated file size:
#' this release bundles files up to 2 MiB and hosts larger files externally.
#' All raw and curated files are also archived on a versioned GitHub Release.
#'
#' @return A data frame with names, storage, URLs, sizes and SHA-256 hashes.
#' @export
#' @examples
#' glyhub_cptac_catalog()[, c("dataset", "kind", "storage", "bytes")]
glyhub_cptac_catalog <- function() {
  utils::read.delim(
    system.file(
      "extdata",
      "CPTAC",
      "manifest.tsv",
      package = "glyhub",
      mustWork = TRUE
    ),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
}

#' Retrieve a CPTAC data file
#'
#' Download a versioned raw TSV gzip archive or curated RDS, with SHA-256
#' verification and persistent caching. Small curated files are bundled.
#'
#' @param cohort Cancer code (for example `"CCRCC"`), or full dataset name
#'   (`"glyhub_CPTAC_CCRCC"`). See [glyhub_cptac_catalog()].
#' @param kind `"curated"` for an RDS or `"raw"` for a gzip-compressed source TSV.
#' @param cache_dir Cache directory. Defaults to `tools::R_user_dir("glyhub",
#'   "cache")`; override with option `glyhub.cache_dir`.
#' @param refresh Download again, even if a valid cached file exists. Bundled
#'   files are always read from the installed package.
#' @param offline Prohibit downloads; fail if a verified local file is absent.
#' @return Absolute path to a verified file. Raw archives preserve the supplied
#'   source bytes, including local cohort-name changes.
#' @details
#' Files are keyed by version and SHA-256. Downloads are validated before
#' replacing cached files. Interrupted downloads do not become cache entries.
#' A corrupt cache entry is downloaded again unless `offline = TRUE`.
#' `refresh = TRUE` and `offline = TRUE` cannot be combined.
#' Remove files in `cache_dir` to clear the cache.
#' @export
#' @examples
#' # Inspect download sizes without accessing the network:
#' subset(glyhub_cptac_catalog(), cohort == "CCRCC")
glyhub_cptac_download <- function(
  cohort,
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  kind <- match.arg(kind)
  if (!is.character(cohort) || length(cohort) != 1L || is.na(cohort)) {
    stop("`cohort` must be one cancer code or dataset name.", call. = FALSE)
  }
  if (
    !is.logical(refresh) ||
      length(refresh) != 1L ||
      is.na(refresh) ||
      !is.logical(offline) ||
      length(offline) != 1L ||
      is.na(offline)
  ) {
    stop("`refresh` and `offline` must be TRUE or FALSE.", call. = FALSE)
  }
  if (refresh && offline) {
    stop("Cannot refresh in offline mode.", call. = FALSE)
  }
  if (
    !is.character(cache_dir) ||
      length(cache_dir) != 1L ||
      is.na(cache_dir) ||
      !nzchar(cache_dir)
  ) {
    stop("`cache_dir` must be one non-empty path.", call. = FALSE)
  }
  cohort <- sub("^glyhub_CPTAC_", "", cohort)
  catalog <- glyhub_cptac_catalog()
  entry <- catalog[
    catalog$cohort == cohort & catalog$kind == kind,
    ,
    drop = FALSE
  ]
  if (nrow(entry) != 1L) {
    stop("Unknown CPTAC cohort: ", cohort, call. = FALSE)
  }
  if (entry$storage == "bundled") {
    path <- system.file(
      "extdata",
      "CPTAC",
      entry$filename,
      package = "glyhub",
      mustWork = TRUE
    )
    if (!.cptac_verified(path, entry)) {
      stop(
        "Bundled CPTAC file failed verification; reinstall glyhub.",
        call. = FALSE
      )
    }
    return(normalizePath(path, mustWork = TRUE))
  }
  directory <- file.path(path.expand(cache_dir), entry$version)
  path <- file.path(directory, paste0(entry$sha256, "-", entry$filename))
  if (!refresh && .cptac_verified(path, entry)) {
    return(normalizePath(path))
  }
  if (offline) {
    stop(
      "No verified cached CPTAC file is available in offline mode.",
      call. = FALSE
    )
  }
  if (
    !dir.exists(directory) &&
      !dir.create(directory, recursive = TRUE, showWarnings = FALSE)
  ) {
    stop("Cannot create CPTAC cache directory.", call. = FALSE)
  }
  temporary <- tempfile(".cptac-", tmpdir = directory)
  on.exit(unlink(temporary), add = TRUE)
  .cptac_download_file(entry$url, temporary)
  if (!.cptac_verified(temporary, entry)) {
    stop(
      "Downloaded CPTAC file failed SHA-256 or size verification.",
      call. = FALSE
    )
  }
  if (!file.rename(temporary, path)) {
    stop("Cannot install verified CPTAC cache file.", call. = FALSE)
  }
  normalizePath(path, mustWork = TRUE)
}

.cptac_verified <- function(path, entry) {
  file.exists(path) &&
    !dir.exists(path) &&
    isTRUE(file.info(path)$size == entry$bytes) &&
    identical(digest::digest(file = path, algo = "sha256"), entry$sha256)
}

.cptac_download_file <- function(url, path) {
  old <- options(timeout = max(600, getOption("timeout", 60)))
  on.exit(options(old))
  status <- utils::download.file(url, path, mode = "wb", method = "libcurl")
  if (status != 0L) stop("CPTAC download failed.", call. = FALSE)
}

.cptac_load <- function(cohort, cache_dir, refresh, offline) {
  path <- glyhub_cptac_download(cohort, "curated", cache_dir, refresh, offline)
  x <- readRDS(path)
  if (!methods::is(x, "GlycoproteomicSE")) {
    stop("Invalid CPTAC object class.", call. = FALSE)
  }
  methods::validObject(x)
  x
}

#' Clear cell renal cell carcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @inheritParams glyhub_cptac_download
#' @return A `GlycoproteomicSE` with all source features and measurement columns.
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for bundled GlycoPOST datasets.
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
#' See [glyhub_cptac_catalog()] for dimensions, sizes and storage location.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_cptac_download()] to retrieve the original TSV archive.
#' @export
glyhub_CPTAC_CCRCC <- function(
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  .cptac_load("CCRCC", cache_dir, refresh, offline)
}

#' Colon adenocarcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @inheritParams glyhub_cptac_download
#' @return A `GlycoproteomicSE` with all source features and measurement columns.
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for bundled GlycoPOST datasets.
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
#' See [glyhub_cptac_catalog()] for dimensions, sizes and storage location.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_cptac_download()] to retrieve the original TSV archive.
#' @export
glyhub_CPTAC_COAD <- function(
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  .cptac_load("COAD", cache_dir, refresh, offline)
}

#' High-grade serous ovarian carcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @inheritParams glyhub_cptac_download
#' @return A `GlycoproteomicSE` with all source features and measurement columns.
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for bundled GlycoPOST datasets.
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
#' See [glyhub_cptac_catalog()] for dimensions, sizes and storage location.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_cptac_download()] to retrieve the original TSV archive.
#' @export
glyhub_CPTAC_HGSC <- function(
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  .cptac_load("HGSC", cache_dir, refresh, offline)
}

#' Head and neck squamous cell carcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @inheritParams glyhub_cptac_download
#' @return A `GlycoproteomicSE` with all source features and measurement columns.
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for bundled GlycoPOST datasets.
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
#' See [glyhub_cptac_catalog()] for dimensions, sizes and storage location.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_cptac_download()] to retrieve the original TSV archive.
#' @export
glyhub_CPTAC_HNSCC <- function(
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  .cptac_load("HNSCC", cache_dir, refresh, offline)
}

#' Lung squamous cell carcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @inheritParams glyhub_cptac_download
#' @return A `GlycoproteomicSE` with all source features and measurement columns.
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for bundled GlycoPOST datasets.
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
#' See [glyhub_cptac_catalog()] for dimensions, sizes and storage location.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_cptac_download()] to retrieve the original TSV archive.
#' @export
glyhub_CPTAC_LSCC <- function(
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  .cptac_load("LSCC", cache_dir, refresh, offline)
}

#' Lung adenocarcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @inheritParams glyhub_cptac_download
#' @return A `GlycoproteomicSE` with all source features and measurement columns.
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for bundled GlycoPOST datasets.
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
#' See [glyhub_cptac_catalog()] for dimensions, sizes and storage location.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_cptac_download()] to retrieve the original TSV archive.
#' @export
glyhub_CPTAC_LUAD <- function(
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  .cptac_load("LUAD", cache_dir, refresh, offline)
}

#' Pancreatic ductal adenocarcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @inheritParams glyhub_cptac_download
#' @return A `GlycoproteomicSE` with all source features and measurement columns.
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for bundled GlycoPOST datasets.
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
#' See [glyhub_cptac_catalog()] for dimensions, sizes and storage location.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_cptac_download()] to retrieve the original TSV archive.
#' @export
glyhub_CPTAC_PDAC <- function(
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  .cptac_load("PDAC", cache_dir, refresh, offline)
}

#' Uterine corpus endometrial carcinoma: CPTAC N-glycoproteome
#'
#' Load the supplied JHU GENCODEv34 median-normalized glycoform-peptide
#' abundance matrix as a [glyexp::GlycoproteomicSE]. Downloads are cached.
#'
#' @inheritParams glyhub_cptac_download
#' @return A `GlycoproteomicSE` with all source features and measurement columns.
#' @details
#' The assay is `2^source_value`, a linearized normalized abundance. Source
#' log2 values, including zeros, are retained in `metadata(x)$raw_abundance`.
#' Source `None` entries become `NA`; no filtering, imputation, aggregation or
#' further normalization is performed. These data are an exception to the
#' zero-to-NA convention used for bundled GlycoPOST datasets.
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
#' See [glyhub_cptac_catalog()] for dimensions, sizes and storage location.
#' @source <https://pdc.cancer.gov/pdc/cptac-pancancer>
#'   Data use and attribution: <https://pdc.cancer.gov/pdc/data-use-guidelines>.
#'   The source data are not licensed under the package's MIT code license.
#' @seealso [glyhub_cptac_download()] to retrieve the original TSV archive.
#' @export
glyhub_CPTAC_UCEC <- function(
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  .cptac_load("UCEC", cache_dir, refresh, offline)
}
