#' Deidentified SerumDiseaseGroups
#'
#' @details
#' Deidentified human-source derivative with unchanged selected quantitative values;
#' original patient identifiers and individual clinical covariates are omitted. Necessary
#' groups, QC and repeat-subject design are retained using study-local anonymous labels.
#'
#' Source scale: Author linear per-sample glycopeptide abundances, separate #PSMs annotation excluded as assay. All source0 preserved; no normalization or imputation added. Quantification implementation not fully specified in current methods; label as author abundance, not asserted raw detector signal..
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
#' A [glyexp::GlycoproteomicSE] with 1114 source rows and 80 measurements.
#' @source \url{https://doi.org/10.1186/s12964-024-01569-y}. CC BY 4.0 author supplementary quantitative data; attribution required
#' @inheritParams glyhub_load
#' @export
glyhub_PMC10983713_N_SerumDiseaseGroups <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PMC10983713_N_SerumDiseaseGroups",
    kind,
    cache_dir,
    refresh,
    offline
  )
}
