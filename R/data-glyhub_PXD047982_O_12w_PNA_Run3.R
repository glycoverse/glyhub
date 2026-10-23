#' Mouse testis source PSM MonoArea 12w PNA 3
#'
#' @details
#' One author run-specific PSM table. Each column is one actual run, not a quantitative
#' metric. Repeated molecular features remain separate source PSM rows, identified by
#' GlySpec/Scan and source row. These objects are not aligned across runs; no merging,
#' summing or filling is performed. IsotopeArea and corrected-area sentinels remain source
#' annotations. Source plausible structures and composition labels are preserved without
#' unverified typed conversion.
#'
#' Source scale: linear author MonoArea per source PSM; not aligned across runs.
#'
#' All original selected source numbers are retained in the assay and
#' `metadata(x)$raw_abundance`, including zeros and missing values.
#' No additional normalization, imputation or inverse transformation is applied.
#' No glycan structures are inferred. Consult metadata for provenance,
#' source row/column coordinates, attribution and limitations.
#'
#' @section Availability:
#' Locally staged for review; requires the maintainer's hash-verified cache.
#' No public data-release URL has been assigned.
#'
#' @format
#' A [glyexp::GlycoproteomicSE] with 557 source rows and 1 measurements.
#' @source \url{https://doi.org/10.1038/s41467-025-57980-7}. CC0-1.0 under iProX dataset policy and verified submission date
#' @inheritParams glyhub_load
#' @export
glyhub_PXD047982_O_12w_PNA_Run3 <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE, offline = FALSE
) {
  glyhub_load("glyhub_PXD047982_O_12w_PNA_Run3", kind, cache_dir, refresh, offline)
}
