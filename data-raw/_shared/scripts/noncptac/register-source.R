# Register a verified source file without requiring a curated SE or changing its values.
register_literature_source <- function(path, spec, cache) {
  if (grepl("^glyhub_PXD057512_", spec$dataset))
    stop("Original acquisition-label linkage remains unresolved; this source asset is on privacy hold")
  privacy_ids <- c("glyhub_MSV000084262_N_XMEN_AuthorProcessed", "glyhub_MSV000086576_N_HCC_AuthorProcessed",
    "glyhub_MSV000086576_N_PDAC_AuthorProcessed", "glyhub_PMC10963274_OxoScan_SourceQuantification",
    "glyhub_PMC9287322_N_PrimaryMyelomaVsBcells_AuthorProcessed", "glyhub_PXD019914_N_Intact_AuthorProcessed",
    "glyhub_PXD019914_N_SPEG_AuthorProcessed", "glyhub_PXD058966_HCC18OSites_SourceQuantification")
  if (spec$dataset %in% privacy_ids && !isTRUE(spec$privacy_derivative))
    stop("Original human-source metadata is not publishable: use privacy-review/build-source-derivatives.R")
  citations <- jsonlite::fromJSON("data-raw/_shared/metadata/noncptac/literature-citations.json")
  spec$citation <- citations[[spec$doi]]
  stopifnot(!is.null(spec$citation))
  stopifnot("glycan_type" %in% names(spec))
  # A null source type is explicitly unknown, never a default N-glycan claim.
  source_type <- if (is.null(spec$glycan_type)) NA_character_ else spec$glycan_type
  if (is.null(spec$curated_status)) {
    spec$curated_status <- "hold: signed author scale; no transformation authorized"
  }
  stopifnot(file.exists(path), identical(digest::digest(file = path, algo = "sha256"), spec$sha256))
  manifest_path <- "inst/extdata/manifest.tsv"
  m <- utils::read.delim(manifest_path, stringsAsFactors = FALSE)
  old <- m[m$dataset == spec$dataset & m$kind == "raw", , drop = FALSE]
  stopifnot(nrow(old) == 0L || all(old$storage == "staged"))
  version <- "literature-source-local-v1"
  filename <- paste0(spec$dataset, ".", spec$format)
  entry <- data.frame(dataset = spec$dataset, source = spec$repository, kind = "raw",
    format = spec$format, storage = "staged", filename = filename,
    bytes = file.info(path)$size, sha256 = spec$sha256, version = version, url = "",
    features = if (is.null(spec$features)) NA_integer_ else spec$features,
    measurements = if (is.null(spec$measurements)) NA_integer_ else spec$measurements)
  target <- file.path(cache, version, paste0(spec$sha256, "-", filename))
  dir.create(dirname(target), recursive = TRUE, showWarnings = FALSE)
  stopifnot(file.copy(path, target, overwrite = TRUE),
    identical(digest::digest(file = target, algo = "sha256"), spec$sha256))
  m <- rbind(m[!(m$dataset == spec$dataset & m$kind == "raw"), ], entry)
  m$url[is.na(m$url)] <- ""
  for (column in c("features", "measurements")) {
    m[[column]][m$storage == "staged" & is.na(m[[column]])] <- "NA"
  }
  utils::write.table(m, manifest_path, sep = "\t", quote = FALSE, row.names = FALSE, na = "")
  meta_path <- "inst/extdata/catalog-metadata.tsv"
  meta <- utils::read.delim(meta_path, stringsAsFactors = FALSE)
  meta <- rbind(meta[meta$dataset != spec$dataset, ], data.frame(dataset = spec$dataset,
    sha256 = spec$sha256, exp_type = "glycoproteomics", glycan_type = source_type,
    has_glycan_structures = NA, quant_method = NA_character_))
  utils::write.table(meta, meta_path, sep = "\t", quote = FALSE, row.names = FALSE, na = "NA")
  jsonlite::write_json(list(manifest = entry, source_provenance = spec,
    exact_bytes_retained = !isTRUE(spec$privacy_derivative), curated_status = spec$curated_status,
    kind_semantics = "raw means source asset, not instrument-raw or unprocessed intensity"),
    file.path("data-raw", spec$accession, paste0(spec$dataset, "-source-receipt.json")),
    pretty = TRUE, auto_unbox = TRUE, null = "null")
  provenance_path <- "inst/extdata/literature-source-metadata.json"
  provenance <- if (file.exists(provenance_path)) {
    jsonlite::fromJSON(provenance_path, simplifyVector = FALSE)
  } else list()
  provenance[[spec$dataset]] <- spec
  # Keep only currently registered source IDs, including explicit unknown types.
  provenance <- provenance[names(provenance) %in% m$dataset[m$kind == "raw"]]
  jsonlite::write_json(provenance, provenance_path, pretty = TRUE, auto_unbox = TRUE, null = "null")
  invisible(entry)
}
