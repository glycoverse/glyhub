#' Cell-surface-capture protein panel DrugResistance
#'
#' @details
#' Preserve complete selected author-processed matrix on its supplied log2 LFQ scale; no
#' new filtering, imputation or transformation. Same study/source family, not independent
#' cohorts. CellLineSurfaceome partly reuses PXD016800 leukemia data; exact shared-control
#' run overlap across panels unresolved because official sample-list downloads failed.
#' Original sample labels, patient input titration and methods preserved; do not infer
#' independence. Preserve every author row, including repeated protein labels; do not
#' deduplicate or infer quantified glycans/sites. These panels share a study source family
#' and are not independent cohorts; accession mapping is retained per source table.
#'
#' Source scale: author log2 LFQ protein surfaceome abundance.
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
#' A [glyexp::GlycoproteomicSE] with 1304 source rows and 25 measurements.
#' @source \url{https://doi.org/10.1038/s41467-022-31810-6}. CC BY 4.0 author supplement; see license_evidence.json
#' @inheritParams glyhub_load
#' @export
glyhub_PMC9287322_N_DrugResistance <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE, offline = FALSE
) {
  glyhub_load("glyhub_PMC9287322_N_DrugResistance", kind, cache_dir, refresh, offline)
}
