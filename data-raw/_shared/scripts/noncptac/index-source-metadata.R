# Rebuild installed source metadata from current staged registration receipts.
m <- utils::read.delim("inst/extdata/manifest.tsv", stringsAsFactors = FALSE)
ids <- m$dataset[m$kind == "raw" & m$storage == "staged"]
paths <- list.files("data-raw", pattern = "-source-receipt\\.json$",
                    full.names = TRUE, recursive = TRUE)
records <- list()
for (path in paths) {
  receipt <- jsonlite::fromJSON(path, simplifyVector = FALSE)
  spec <- receipt$source_provenance
  if (spec$dataset %in% ids) {
    if (spec$dataset %in% c("glyhub_MSV000084262_N_XMEN_AuthorProcessed", "glyhub_MSV000086576_N_HCC_AuthorProcessed", "glyhub_MSV000086576_N_PDAC_AuthorProcessed", "glyhub_PMC10963274_OxoScan_SourceQuantification", "glyhub_PMC9287322_N_PrimaryMyelomaVsBcells_AuthorProcessed", "glyhub_PXD019914_N_Intact_AuthorProcessed", "glyhub_PXD019914_N_SPEG_AuthorProcessed", "glyhub_PXD058966_HCC18OSites_SourceQuantification")) stopifnot(isTRUE(spec$privacy_derivative))
    if (!length(spec$glycan_type)) spec$glycan_type <- NULL
    records[[spec$dataset]] <- spec
  }
}
stopifnot(setequal(names(records), ids))
jsonlite::write_json(records[sort(names(records))],
  "inst/extdata/literature-source-metadata.json", pretty = TRUE,
  auto_unbox = TRUE, null = "null")
