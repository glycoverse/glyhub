# Source from a study builder with `cache` set. No publication occurs here.
register_literature <- function(x, name, title, details) {
  source("data-raw/_shared/scripts/noncptac/privacy.R", local = TRUE)
  x <- redact_literature_subjects(x, name)
  md <- S4Vectors::metadata(x)
  citations <- jsonlite::fromJSON("data-raw/_shared/metadata/noncptac/literature-citations.json")
  citation <- citations[[md$doi]]
  stopifnot(!is.null(citation))
  md$citation <- citation
  md$attribution <- paste(citation$authors, paste0("(", citation$year, ")."),
    citation$title, citation$url)
  details <- if (isTRUE(md$privacy_redacted)) c("Deidentified human-source derivative with unchanged selected quantitative values; original patient identifiers and individual clinical covariates are omitted.", "Necessary groups, QC and repeat-subject design are retained using study-local anonymous labels.") else details
  transformed <- !is.null(md$assay_transformation)
  if (transformed) {
    stopifnot(identical(md$doi, "10.1038/s41467-020-19976-3"),
      identical(md$assay_transformation, "2^source_log2_normalized_ratio"))
    md$format_adaptation <- "Author log2 normalized ratios converted to linear relative ratios by 2^x; original log2 matrix retained"
  } else {
    md$format_adaptation <- "Original author-selected measurements reshaped into a GlycoproteomicSE; no additional numerical transformation"
  }
  S4Vectors::metadata(x) <- md
  source("data-raw/_shared/scripts/noncptac/register.R", local = TRUE)
  dir.create("data-raw/_shared/artifacts/noncptac/assets", recursive = TRUE,
             showWarnings = FALSE)
  before <- utils::read.delim("inst/extdata/manifest.tsv")
  existing <- before[before$dataset == name, , drop = FALSE]
  stopifnot(nrow(existing) == 0L || all(existing$storage == "staged"))
  register(x, name, compression = "gzip")
  for (path in c("inst/extdata/manifest.tsv",
                 "data-raw/_shared/metadata/noncptac/manifest.tsv")) {
    values <- utils::read.delim(path, stringsAsFactors = FALSE)
    values$url[is.na(values$url)] <- ""
    for (column in c("features", "measurements")) {
      values[[column]][values$storage == "staged" & is.na(values[[column]])] <- "NA"
    }
    if (!is.null(md$source_repository)) {
      values$source[values$dataset == name] <- md$source_repository
    }
    utils::write.table(values, path, sep = "\t", quote = FALSE,
                       row.names = FALSE, na = "")
  }
  manifest <- utils::read.delim("inst/extdata/manifest.tsv")
  e <- manifest[manifest$dataset == name, , drop = FALSE]
  receipt_path <- file.path("data-raw", strsplit(name, "_", fixed = TRUE)[[1]][2],
    paste0(name, "-receipt.json"))
  receipt <- jsonlite::fromJSON(receipt_path, simplifyVector = FALSE)
  receipt$manifest <- e
  jsonlite::write_json(receipt, receipt_path, pretty = TRUE, auto_unbox = TRUE,
    null = "null")
  rd <- SummarizedExperiment::rowData(x)
  meta <- utils::read.delim("inst/extdata/catalog-metadata.tsv")
  entry <- data.frame(
    dataset = name, sha256 = e$sha256, exp_type = "glycoproteomics",
    glycan_type = md$glycan_type,
    has_glycan_structures = "glycan_structure" %in% names(rd) &&
      any(!is.na(rd$glycan_structure)), quant_method = md$assay_scale
  )
  meta <- rbind(meta[meta$dataset != name, ], entry)
  utils::write.table(meta, "inst/extdata/catalog-metadata.tsv",
                     sep = "\t", quote = FALSE, row.names = FALSE, na = "NA")
  text <- c(
    paste0("#' ", title), "#'",
    "#' @details",
    paste0("#' ", strwrap(paste(details, collapse = " "), width = 88)), "#'",
    paste0("#' Source scale: ", md$assay_scale, "."), "#'",
    if (transformed) c(
      "#' Assay values are 2^x of author-normalized log2 ratios: linear relative ratios, not raw intensity.",
      "#' The original log2 matrix is retained in `metadata(x)$raw_abundance`; source zero becomes one.",
      "#' Missing values remain missing. No further normalization or imputation is applied."
    ) else c(
      "#' All original selected source numbers are retained in the assay and",
      "#' `metadata(x)$raw_abundance`, including zeros and missing values.",
      "#' No additional normalization, imputation or inverse transformation is applied."
    ),
    "#' No glycan structures are inferred. Consult metadata for provenance,",
    "#' source row/column coordinates, attribution and limitations.", "#'",
    "#' @section Availability:",
    "#' Locally staged for review; requires the maintainer's hash-verified cache.",
    "#' No public data-release URL has been assigned.", "#'",
    "#' @format",
    sprintf(if (!is.null(md$source_experiments)) "#' A [glyexp::GlycoproteomicSE] with %s union feature rows and %s measurements." else "#' A [glyexp::GlycoproteomicSE] with %s source rows and %s measurements.",
            nrow(x), ncol(x)),
    paste0("#' @source \\url{https://doi.org/", md$doi, "}. ", md$license),
    "#' @inheritParams glyhub_load", "#' @export",
    paste0(name, " <- function("),
    "  kind = c(\"curated\", \"raw\"),",
    "  cache_dir = getOption(\"glyhub.cache_dir\", tools::R_user_dir(\"glyhub\", \"cache\")),",
    "  refresh = FALSE, offline = FALSE",
    ") {", sprintf('  glyhub_load("%s", kind, cache_dir, refresh, offline)', name), "}"
  )
  writeLines(text, file.path("R", paste0("data-", name, ".R")))
  cached <- file.path(cache, e$version, paste0(e$sha256, "-", e$filename))
  stopifnot(identical(readRDS(cached), x))
  invisible(e)
}
