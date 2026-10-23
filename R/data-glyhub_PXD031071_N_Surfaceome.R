#' MCF10A EMT gene-level N-enriched surfaceome expression
#'
#' @details
#' Complete author GLYCO table: 549 genes and ten timepoints with three biological
#' replicates each. This is protein-enriched surfaceome expression, not intact
#' glycopeptide or glycosite quantification. Only source gene labels are supplied; protein
#' accessions, sites and glycan compositions remain unknown. Authors describe log2
#' transformation, normalization and LLS imputation; the precise stage of this published
#' sheet is unresolved. Values are retained without further processing and are not raw
#' intensity.
#'
#' Source scale: author-processed log2 surfaceome expression; exact published processing stage unresolved.
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
#' A [glyexp::GlycoproteomicSE] with 549 source rows and 30 measurements.
#' @source \url{https://doi.org/10.1038/s41467-023-36122-x}. CC BY 4.0 original-author GLYCO supplementary matrix; no separate exclusion identified. Format conversion only.
#' @inheritParams glyhub_load
#' @export
glyhub_PXD031071_N_Surfaceome <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE, offline = FALSE
) {
  glyhub_load("glyhub_PXD031071_N_Surfaceome", kind, cache_dir, refresh, offline)
}
