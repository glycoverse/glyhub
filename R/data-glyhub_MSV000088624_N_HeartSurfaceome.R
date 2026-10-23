#' Deidentified HeartSurfaceome
#'
#' @details
#' Deidentified human-source derivative with unchanged selected quantitative values;
#' original patient identifiers and individual clinical covariates are omitted. Necessary
#' groups, QC and repeat-subject design are retained using study-local anonymous labels.
#'
#' Source scale: author log2 normalized protein surfaceome abundance; upstream author imputation.
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
#' A [glyexp::GlycoproteomicSE] with 490 source rows and 7 measurements.
#' @source \url{https://doi.org/10.1038/s44161-022-00200-y}. CC BY 4.0 original-author supplementary measurements; no separate exclusion identified
#' @inheritParams glyhub_load
#' @export
glyhub_MSV000088624_N_HeartSurfaceome <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_MSV000088624_N_HeartSurfaceome",
    kind,
    cache_dir,
    refresh,
    offline
  )
}
