#' N/TERT-1 Secretome_GALNT1_GALNT2 O-glycopeptide reporter abundance
#'
#' @details
#' Author site-associated glycopeptide rows, with full source TMT6plex measurements. A
#' multisite peptide's signal is copied by the authors to its constituent sites; those
#' rows are not independent quantified sites. Source T/Tn labels are retained. One shared
#' GALNT1/GALNT2 secretome experiment, with WT channels retained only once.
#'
#' Source scale: Linear author-normalized TMT6plex reporter abundance; source total-peptide-level normalization.
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
#' A [glyexp::GlycoproteomicSE] with 987 source rows and 6 measurements.
#' @source \url{https://doi.org/10.1038/s41467-022-33806-8}. CC BY 4.0; original-author supplementary abundance table, no separate exclusion located
#' @inheritParams glyhub_load
#' @export
glyhub_PXD036791_O_Secretome_GALNT1_GALNT2 <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PXD036791_O_Secretome_GALNT1_GALNT2",
    kind,
    cache_dir,
    refresh,
    offline
  )
}
