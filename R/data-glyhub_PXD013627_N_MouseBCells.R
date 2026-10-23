#' Mouse B-cell N-glyco-enriched protein abundance
#'
#' @details
#' 9 B-cell stages, 28 columns. Methods says31 but actual supplied table28; preserve
#' supplied columns. N-glyco-enriched protein groups from deamidated sequon peptides, not
#' intact glycopeptides. No glycan compositions or quantitative protein sites are
#' available. The author-normalized log2 abundance remains log2; it is not raw MS
#' intensity.
#'
#' Source scale: log2 author-normalized MSstats protein abundance; keep original log2.
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
#' A [glyexp::GlycoproteomicSE] with 147 source rows and 28 measurements.
#' @source \url{https://doi.org/10.1038/s41467-019-13418-5}. CC BY 4.0; original-author supplementary abundance table, no separate exclusion located
#' @inheritParams glyhub_load
#' @export
glyhub_PXD013627_N_MouseBCells <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PXD013627_N_MouseBCells",
    kind,
    cache_dir,
    refresh,
    offline
  )
}
