#' Schistosoma mansoni adult-worm source N-glycan-site abundance
#'
#' @details
#' Three female-labelled and three male-labelled whole-adult-worm measurements. Replicate
#' biological independence is not reported. The study's tissue-specific transcriptomic
#' analyses do not imply tissue-resolved mass-spectrometry samples. All 3,274 source
#' site/composition rows are retained. Ambiguous protein/site groups are not expanded or
#' assigned a guessed single accession or position. Author downstream protein
#' normalization and Perseus processing are not reapplied.
#'
#' Source scale: Author pGlycoQuant site-specific glycan abundance; before subsequent protein-ratio normalization and Perseus log2/filtering/imputation.
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
#' A [glyexp::GlycoproteomicSE] with 3274 source rows and 6 measurements.
#' @source \url{https://doi.org/10.1038/s41467-026-68400-9}. MassIVE deposited dataset: CC0-1.0; not the publisher supplement license
#' @inheritParams glyhub_load
#' @export
glyhub_MSV000097695_N_AdultWorm <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE, offline = FALSE
) {
  glyhub_load("glyhub_MSV000097695_N_AdultWorm", kind, cache_dir, refresh, offline)
}
