#' Plasma extracellular-vesicle N-glyco enrichment method comparison
#'
#' @details
#' Complete 1527-row author native site-group table with six technical measurements.
#' Includes reverse and potential-contaminant rows; use explicit row_role and source flags
#' when selecting biological targets. All original source columns, multiplicity
#' alternatives, zeros and ambiguous groups remain available. No new filtering,
#' normalization or imputation; these are not six independent patients.
#'
#' Source scale: author native MaxQuant site-group intensity; not LFQ or downstream imputed abundance.
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
#' A [glyexp::GlycoproteomicSE] with 1527 source rows and 6 measurements.
#' @source \url{https://doi.org/10.1038/s41596-019-0260-5}. CC0 1.0 repository dataset
#' @inheritParams glyhub_load
#' @export
glyhub_PXD013893_N_EVEnrichmentMethods <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE, offline = FALSE
) {
  glyhub_load("glyhub_PXD013893_N_EVEnrichmentMethods", kind, cache_dir, refresh, offline)
}
