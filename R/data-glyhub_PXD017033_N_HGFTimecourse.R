#' HGF time-course glycopeptide reporter intensities in two cell lines
#'
#' @details
#' Complete SMMC-7721 and HepG2 TMT reporter experiments joined only on all ten exact
#' author feature annotations. Cell-line and batch are explicit; six timepoints per cell
#' line are six measured pools, each from three biological replicates. Structural NA
#' denotes features absent from one source table; author zeros and missingness are
#' independently retained. Original experiments, PSM counts, alternative processed columns
#' and exact row/column maps remain available in metadata. Seven source annotation
#' conflicts retain both source labels and unknown canonical composition; no topology is
#' inferred. No interplex normalization, imputation, filtering or additional value
#' transformation.
#'
#' Source scale: Author reporter-ion intensity columns, distinct from provided normalized abundance and baseline-ratio columns; PSM column is annotation only.
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
#' A [glyexp::GlycoproteomicSE] with 2318 union feature rows and 12 measurements.
#' @source \url{https://doi.org/10.7150/thno.56882}. CC BY 4.0 author supplementary quantitative data; attribution required
#' @inheritParams glyhub_load
#' @export
glyhub_PXD017033_N_HGFTimecourse <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PXD017033_N_HGFTimecourse",
    kind,
    cache_dir,
    refresh,
    offline
  )
}
