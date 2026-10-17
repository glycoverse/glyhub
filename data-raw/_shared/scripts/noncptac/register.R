register <- function(x, name, compression = "xz") {
  stopifnot(methods::validObject(x))
  file <- file.path(
    "data-raw/_shared/artifacts/noncptac/assets",
    paste0(name, ".rds")
  )
  saveRDS(x, file, compress = compression, version = 3)
  entry <- data.frame(
    dataset = name,
    source = if (grepl("MSV", name)) {
      "MassIVE"
    } else if (grepl("IPX", name)) {
      "iProX"
    } else if (grepl("PXD065283", name)) {
      "jPOST"
    } else {
      "PRIDE"
    },
    kind = "curated",
    format = "rds",
    storage = "staged",
    filename = basename(file),
    bytes = file.info(file)$size,
    sha256 = digest::digest(file = file, algo = "sha256"),
    version = "noncptac-local-v1",
    url = "",
    features = nrow(x),
    measurements = ncol(x)
  )
  for (mp in c(
    "inst/extdata/manifest.tsv",
    "data-raw/_shared/metadata/noncptac/manifest.tsv"
  )) {
    m <- utils::read.delim(mp, stringsAsFactors = FALSE)
    m <- rbind(m[m$dataset != name, ], entry)
    utils::write.table(m, mp, sep = "\t", quote = FALSE, row.names = FALSE)
  }
  dir.create(
    file.path(cache, entry$version),
    recursive = TRUE,
    showWarnings = FALSE
  )
  stopifnot(file.copy(
    file,
    file.path(cache, entry$version, paste0(entry$sha256, "-", entry$filename)),
    overwrite = TRUE
  ))
  jsonlite::write_json(
    list(
      dataset = name,
      dimensions = dim(x),
      manifest = entry,
      provenance = S4Vectors::metadata(x)$source_provenance,
      missing = sum(is.na(SummarizedExperiment::assay(x))),
      zero = sum(SummarizedExperiment::assay(x) == 0, na.rm = TRUE),
      typed_composition_missing = sum(is.na(
        SummarizedExperiment::rowData(x)$glycan_composition
      ))
    ),
    file.path(
      "data-raw",
      strsplit(name, "_", fixed = TRUE)[[1]][2],
      paste0(name, "-receipt.json")
    ),
    pretty = TRUE,
    auto_unbox = TRUE
  )
  print(entry)
}
