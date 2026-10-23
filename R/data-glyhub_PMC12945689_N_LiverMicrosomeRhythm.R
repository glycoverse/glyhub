#' LiverMicrosomeRhythm
#'
#' @details
#' Wild-type mice, 8 zeitgeber timepoints ZT0,3,6,9,12,15,18,21; workbook Legend
#' explicitly two biological replicates rep1/rep2; no inference of longitudinal sampling
#' from same animal intact N-glycopeptides from mouse liver microsomes Complete selected
#' source rows and measurements retained without additional numerical processing.
#'
#' Source scale: Author relative abundance (workbook Legend); positive values, not log-transformed. Exact normalization origin unresolved and must not be labelled raw instrument intensity..
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
#' A [glyexp::GlycoproteomicSE] with 484 source rows and 16 measurements.
#' @source \url{https://doi.org/10.1038/s42255-026-01453-8}. CC BY 4.0 author supplement; license_evidence.json
#' @inheritParams glyhub_load
#' @export
glyhub_PMC12945689_N_LiverMicrosomeRhythm <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PMC12945689_N_LiverMicrosomeRhythm",
    kind,
    cache_dir,
    refresh,
    offline
  )
}
