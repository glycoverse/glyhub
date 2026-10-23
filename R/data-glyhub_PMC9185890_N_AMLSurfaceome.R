#' Deidentified AMLSurfaceome
#'
#' @details
#' Deidentified human-source derivative with unchanged selected quantitative values;
#' original patient identifiers and individual clinical covariates are omitted. Necessary
#' groups, QC and repeat-subject design are retained using study-local anonymous labels.
#'
#' Source scale: source positive linear intensity / iBAQ-like table values; author narrative describes later log2 median normalization and figure log10 averages, but source table is NOT those logs; retain exact source values and describe scale uncertainty.
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
#' A [glyexp::GlycoproteomicSE] with 622 source rows and 18 measurements.
#' @source \url{https://doi.org/10.1186/s40364-022-00390-4}. CC BY4.0 author supplementary data; license_evidence.json
#' @inheritParams glyhub_load
#' @export
glyhub_PMC9185890_N_AMLSurfaceome <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE, offline = FALSE
) {
  glyhub_load("glyhub_PMC9185890_N_AMLSurfaceome", kind, cache_dir, refresh, offline)
}
