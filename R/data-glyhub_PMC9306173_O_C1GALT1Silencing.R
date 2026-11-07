#' C1GALT1Silencing
#'
#' @details
#' YTS-1 bladder cancer cells, control vs doxycycline-induced C1GALT1 silencing,
#' triplicate LC-MS/MS. Source does not establish biological independence vs technical
#' injection; replicate type explicitly unknown. O-glycopeptide source rows (117 reported
#' glycopeptides,67 proteins), source ambiguous localization and sequence window preserved
#' Complete selected source rows and measurements retained without additional numerical
#' processing.
#'
#' Source scale: author Intensity columns, positive linear; do not treat zeros as absent rows or impute.
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
#' A [glyexp::GlycoproteomicSE] with 117 source rows and 6 measurements.
#' @source \url{https://doi.org/10.1186/s13046-022-02438-7}. CC BY4.0 author supplementary data; license_evidence.json
#' @inheritParams glyhub_load
#' @export
glyhub_PMC9306173_O_C1GALT1Silencing <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PMC9306173_O_C1GALT1Silencing",
    kind,
    cache_dir,
    refresh,
    offline
  )
}
