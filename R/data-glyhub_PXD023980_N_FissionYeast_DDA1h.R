#' GproDIA source N-glycopeptide panel FissionYeast_DDA1h
#'
#' @details
#' Technical repeat injections, NOT biological independent subjects. Same underlying
#' sample measured by DDA/DIA variants; objects must not be counted as independent
#' biological cohorts. Main default SSL result chosen; same-run LRL/EXL reanalyses
#' retained in original-source workbook assets not claimed independent datasets.
#' Site-Glycans/Glycosites are same-measurement author aggregate views, not independent
#' cohorts. Complete selected author precursor matrix retained; no newly aligned or
#' aggregated features. Source peptide, composition, charge and ambiguous protein/site
#' annotations are preserved.
#'
#' Source scale: author-provided linear DDA precursor abundance; normalization status not established for this table.
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
#' A [glyexp::GlycoproteomicSE] with 666 source rows and 4 measurements.
#' @source \url{https://doi.org/10.1038/s41467-021-26246-3}. CC BY4.0 author supplement; does not claim iProX independent deposit license
#' @inheritParams glyhub_load
#' @export
glyhub_PXD023980_N_FissionYeast_DDA1h <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PXD023980_N_FissionYeast_DDA1h",
    kind,
    cache_dir,
    refresh,
    offline
  )
}
