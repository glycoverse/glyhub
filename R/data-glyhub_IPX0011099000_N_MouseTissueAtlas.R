#' Mouse tissue atlas source precursor abundance across 154 LC-MS/MS runs
#'
#' @details
#' 154 source LC-MS/MS runs across 5 tissues, 3 enzyme combinations and 2 enrichment
#' protocols; preserve actual run list. Five LC-MS/MS replicates reported, not necessarily
#' independent biological subjects. Exact enzyme/enrichment/tissue from SD1; do not infer
#' individual sex/donor IDs. Author total-intensity-normalized, log2-processed expression
#' matrix. Authors report zero imputation; source zeros retained exactly and not
#' reinterpreted or filled. No additional normalization/log/exponentiation/aggregation.
#' Not raw XIC areas. Existing glyhub_IPX0011099000_N_Brain is distinct IPX0011099004
#' PD-AD brain cohort, 20191x60; this 154-run five-tissue protocol atlas is not
#' represented there. Source tissue, enzyme and enrichment labels are matched exactly from
#' the author's run table. 154 runs must not be interpreted as 154 independent animals;
#' source-zero provenance is not reconstructed.
#'
#' Source scale: author total-intensity-normalized log2 matrix with author-filled zeros; not raw intensity.
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
#' A [glyexp::GlycoproteomicSE] with 40466 source rows and 154 measurements.
#' @source \url{https://doi.org/10.1038/s41467-025-60437-6}. iProX dataset CC0, exact project submitTime 2025-03-04 after 2023-03-23 policy date. Applies to repository copy; do not generalize to NCND publisher attachments.
#' @inheritParams glyhub_load
#' @export
glyhub_IPX0011099000_N_MouseTissueAtlas <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_IPX0011099000_N_MouseTissueAtlas",
    kind,
    cache_dir,
    refresh,
    offline
  )
}
