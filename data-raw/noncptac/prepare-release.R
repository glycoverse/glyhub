# Metadata-only preparation of the license-cleared batch; no upload or Git action.
devtools::load_all(quiet = TRUE)
tag <- "data-v0.1.0"
root <- "data-raw/noncptac"
decisions <- jsonlite::fromJSON(file.path(root, "publication-decisions.json"))
m <- read.delim(file.path(root, "manifest.tsv"), stringsAsFactors = FALSE)
m$url[is.na(m$url)] <- ""
validation <- jsonlite::fromJSON(
  file.path(root, "validation-all.json"),
  simplifyVector = FALSE
)
pins <- jsonlite::fromJSON(
  file.path(root, "completed-source-checks.json"),
  simplifyVector = FALSE
)
checks <- list()
for (name in decisions$dataset[
  decisions$publish & decisions$source_license == "CC0-1.0"
]) {
  i <- match(name, m$dataset)
  path <- file.path(root, "assets", m$filename[i])
  old <- readRDS(path)
  old_hash <- digest::digest(file = path, algo = "sha256")
  x <- old
  md <- S4Vectors::metadata(x)
  acc <- strsplit(name, "_", fixed = TRUE)[[1]][2]
  md$license <- "Deposited PRIDE source data: CC0-1.0, explicitly declared by the project API. Source scientific values retained; cite the original authors and project."
  md$redistribution <- list(
    source_license = "CC0-1.0",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/",
    project_license_evidence = paste0(
      "https://www.ebi.ac.uk/pride/ws/archive/v2/projects/",
      acc
    ),
    checked = "2026-10-17",
    attribution_doi = md$doi,
    changes = "Reshaped to GlycoproteomicSE; source numeric values and annotations retained. See processing and source_provenance."
  )
  S4Vectors::metadata(x) <- md
  saveRDS(x, path, compress = "gzip", version = 3)
  y <- readRDS(path)
  stopifnot(
    methods::validObject(y),
    identical(SummarizedExperiment::assay(old), SummarizedExperiment::assay(y)),
    identical(
      SummarizedExperiment::rowData(old),
      SummarizedExperiment::rowData(y)
    ),
    identical(
      SummarizedExperiment::colData(old),
      SummarizedExperiment::colData(y)
    )
  )
  old_md <- S4Vectors::metadata(old)
  keep <- setdiff(names(old_md), c("license", "redistribution"))
  stopifnot(identical(old_md[keep], S4Vectors::metadata(y)[keep]))
  hash <- digest::digest(file = path, algo = "sha256")
  m$sha256[i] <- hash
  m$bytes[i] <- file.info(path)$size
  m$storage[i] <- "release"
  m$version[i] <- tag
  m$url[i] <- paste0(
    "https://github.com/glycoverse/glyhub/releases/download/",
    tag,
    "/",
    m$filename[i]
  )
  validation[[name]]$sha256 <- hash
  validation[[name]]$license_metadata_update <- list(
    previous_sha256 = old_hash,
    assay_annotations_and_other_metadata_identical = TRUE
  )
  pins[[name]] <- list(
    sha256 = hash,
    compared_cells = validation[[name]]$source_cells_compared,
    evidence = "validation-all.json plus release-preparation-checks.json: source-validated numbers and annotations unchanged by license metadata update"
  )
  checks[[name]] <- list(
    previous_sha256 = old_hash,
    sha256 = hash,
    bytes = m$bytes[i],
    assay_annotations_and_other_metadata_identical = TRUE
  )
  cache <- file.path("../noncptac-cache", tag)
  dir.create(cache, recursive = TRUE, showWarnings = FALSE)
  stopifnot(file.copy(
    path,
    file.path(cache, paste0(hash, "-", m$filename[i])),
    overwrite = TRUE
  ))
  rm(old, x, y)
  gc()
}
write.table(
  m,
  file.path(root, "manifest.tsv"),
  sep = "\t",
  quote = FALSE,
  row.names = FALSE,
  na = ""
)
all <- read.delim("inst/extdata/manifest.tsv", stringsAsFactors = FALSE)
all$url[is.na(all$url)] <- ""
for (i in seq_len(nrow(m))) {
  all[all$dataset == m$dataset[i] & all$kind == "curated", ] <- m[i, ]
}
write.table(
  all,
  "inst/extdata/manifest.tsv",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE,
  na = ""
)
jsonlite::write_json(
  validation,
  file.path(root, "validation-all.json"),
  pretty = TRUE,
  auto_unbox = TRUE
)
jsonlite::write_json(
  pins,
  file.path(root, "completed-source-checks.json"),
  pretty = TRUE,
  auto_unbox = TRUE
)
jsonlite::write_json(
  checks,
  file.path(root, "release-preparation-checks.json"),
  pretty = TRUE,
  auto_unbox = TRUE
)
