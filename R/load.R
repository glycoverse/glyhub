#' List available glyhub datasets
#'
#' List released and locally staged datasets without downloading any files.
#' Data assets are excluded from the package. A staged entry has no download
#' URL and requires the maintainer's verified local cache.
#'
#' @param kind List `"curated"` datasets (default), `"raw"` source archives,
#'   or `"all"` resources. Raw archives are currently available for CPTAC only.
#' @return A data frame containing dataset identifiers, source, file format,
#'   storage, compressed bytes, SHA-256, version, URL and dimensions.
#' @export
#' @examples
#' glyhub_catalog()[, c("dataset", "storage", "bytes")]
glyhub_catalog <- function(kind = c("curated", "raw", "all")) {
  kind <- match.arg(kind)
  catalog <- utils::read.delim(
    system.file("extdata", "manifest.tsv", package = "glyhub", mustWork = TRUE),
    stringsAsFactors = FALSE
  )
  if (kind != "all") {
    catalog <- catalog[catalog$kind == kind, , drop = FALSE]
  }
  rownames(catalog) <- NULL
  catalog
}

#' Load any glyhub dataset
#'
#' Load any dataset from the shared external data release. Dataset identifiers
#' also name convenience functions that call this loader with the same options.
#'
#' @param dataset Exact dataset identifier from [glyhub_catalog()], for example
#'   `"glyhub_GPST000738_N_B4GalT1"` or `"glyhub_CPTAC_CCRCC"`.
#' @param kind `"curated"` returns a data object; `"raw"` returns the path to
#'   a verified source archive. Raw archives are currently available for CPTAC.
#' @param cache_dir Cache directory, defaulting to
#'   `tools::R_user_dir("glyhub", "cache")`. Set option `glyhub.cache_dir`
#'   to change the default.
#' @param refresh Download the pinned resource again, even if cached.
#' @param offline Prohibit downloads; require a verified local resource.
#' @return For `kind = "curated"`, a [glyexp::GlycomicSE] or
#'   [glyexp::GlycoproteomicSE]. For `kind = "raw"`, an absolute file path.
#' @details
#' Downloads and cached files are checked against the package's size and
#' SHA-256 manifest before use. Files are cached by version and hash.
#' Interrupted or invalid downloads never replace a verified cached file.
#' `refresh = TRUE` cannot be combined with `offline = TRUE`.
#' Delete downloaded files from `cache_dir` to clear the cache.
#'
#' Dataset objects are no longer exposed through LazyData or `data()`. Use this
#' loader or each dataset's same-named function. Both return identical objects
#' and share the verified cache. Consult dataset help for scientific details.
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
#' @examples
#' glyhub_catalog()[1:3, c("dataset", "bytes")]
glyhub_load <- function(
  dataset,
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  kind <- match.arg(kind)
  if (
    !is.character(dataset) ||
      length(dataset) != 1L ||
      is.na(dataset) ||
      !nzchar(dataset)
  ) {
    stop(
      "`dataset` must be one identifier from glyhub_catalog().",
      call. = FALSE
    )
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
  catalog <- glyhub_catalog("all")
  entry <- catalog[
    catalog$dataset == dataset & catalog$kind == kind,
    ,
    drop = FALSE
  ]
  if (nrow(entry) != 1L) {
    stop(
      "Unknown dataset or unavailable resource kind: ",
      dataset,
      " (",
      kind,
      ").",
      call. = FALSE
    )
  }
  path <- .glyhub_resource_file(entry, cache_dir, refresh, offline)
  if (kind == "raw") {
    return(path)
  }
  if (entry$format == "rds") {
    x <- readRDS(path)
  } else if (entry$format == "rda") {
    env <- new.env(parent = emptyenv())
    loaded <- load(path, envir = env)
    if (!identical(loaded, dataset)) {
      stop("Unexpected object in glyhub resource.", call. = FALSE)
    }
    x <- env[[dataset]]
  } else {
    stop("Unsupported glyhub resource format.", call. = FALSE)
  }
  if (!methods::is(x, "GlycomicSE") && !methods::is(x, "GlycoproteomicSE")) {
    stop("Invalid glyhub resource class.", call. = FALSE)
  }
  methods::validObject(x)
  x
}

.glyhub_resource_file <- function(entry, cache_dir, refresh, offline) {
  directory <- file.path(path.expand(cache_dir), entry$version)
  path <- file.path(directory, paste0(entry$sha256, "-", entry$filename))
  if (!refresh && .glyhub_verified(path, entry)) {
    return(normalizePath(path))
  }
  if (offline) {
    stop(
      "No verified cached glyhub file is available in offline mode.",
      call. = FALSE
    )
  }
  if (is.na(entry$url) || !nzchar(entry$url)) {
    stop(
      "This dataset is locally staged and has no published download URL. ",
      "Build and seed its verified cache using data-raw/noncptac/build.R.",
      call. = FALSE
    )
  }
  if (
    !dir.exists(directory) &&
      !dir.create(directory, recursive = TRUE, showWarnings = FALSE)
  ) {
    stop("Cannot create glyhub cache directory.", call. = FALSE)
  }
  temporary <- tempfile(".glyhub-", tmpdir = directory)
  on.exit(unlink(temporary), add = TRUE)
  .glyhub_download_file(entry$url, temporary)
  if (!.glyhub_verified(temporary, entry)) {
    stop(
      "Downloaded glyhub file failed SHA-256 or size verification.",
      call. = FALSE
    )
  }
  if (!file.rename(temporary, path)) {
    stop("Cannot install verified glyhub cache file.", call. = FALSE)
  }
  normalizePath(path, mustWork = TRUE)
}

.glyhub_verified <- function(path, entry) {
  file.exists(path) &&
    !dir.exists(path) &&
    isTRUE(file.info(path)$size == entry$bytes) &&
    identical(digest::digest(file = path, algo = "sha256"), entry$sha256)
}

.glyhub_download_file <- function(url, path) {
  old <- options(timeout = max(600, getOption("timeout", 60)))
  on.exit(options(old))
  status <- utils::download.file(url, path, mode = "wb", method = "libcurl")
  if (status != 0L) stop("glyhub download failed.", call. = FALSE)
}
