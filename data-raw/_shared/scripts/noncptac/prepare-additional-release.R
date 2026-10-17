# Publish the five additional numerical objects without asserting a new license.
devtools::load_all(quiet = TRUE)
decisions <- jsonlite::fromJSON(
  "data-raw/_shared/metadata/noncptac/publication-decisions.json"
)
names <- decisions$dataset[
  decisions$publish &
    decisions$source_license == "unresolved-for-complete-object" &
    decisions$dataset != "glyhub_MSV000089484_N_HCC"
]
m <- read.delim(
  "data-raw/_shared/metadata/noncptac/manifest.tsv",
  stringsAsFactors = FALSE
)
validation <- jsonlite::fromJSON(
  "data-raw/_shared/reports/noncptac/validation-all.json",
  simplifyVector = FALSE
)
pins <- jsonlite::fromJSON(
  "data-raw/_shared/reports/noncptac/completed-source-checks.json",
  simplifyVector = FALSE
)
checks <- list()
for (name in names) {
  i <- match(name, m$dataset)
  path <- file.path("data-raw/_shared/artifacts/noncptac/assets", m$filename[i])
  old <- readRDS(path)
  old_hash <- digest::digest(file = path, algo = "sha256")
  md <- S4Vectors::metadata(old)
  previous <- md
  md$license <- sub(
    "; local staging only",
    "; source-license scope remains unresolved; no new license granted",
    md$license,
    fixed = TRUE
  )
  md$publication <- list(
    source_license_status = "unresolved-for-complete-object",
    authorization = "Published at explicit user request after disclosure of unresolved source-license scope. This does not establish or grant a new license.",
    evidence_url = decisions$evidence_url[match(name, decisions$dataset)],
    attribution_doi = md$doi,
    changes = "Reshaped factual numerical data with source annotations and processing records. No article text, figures or original attachment archive is redistributed.",
    recorded = "2026-10-17"
  )
  x <- old
  S4Vectors::metadata(x) <- md
  saveRDS(x, path, compress = "gzip", version = 3)
  y <- readRDS(path)
  stopifnot(methods::validObject(y))
  S4Vectors::metadata(y) <- previous
  stopifnot(identical(old, y))
  hash <- digest::digest(file = path, algo = "sha256")
  m$sha256[i] <- hash
  m$bytes[i] <- file.info(path)$size
  m$storage[i] <- "release"
  m$version[i] <- "data-v0.1.0"
  m$url[i] <- paste0(
    "https://github.com/glycoverse/glyhub/releases/download/data-v0.1.0/",
    m$filename[i]
  )
  checks[[name]] <- list(
    previous_sha256 = old_hash,
    sha256 = hash,
    bytes = m$bytes[i],
    all_content_except_license_and_publication_identical = TRUE
  )
  validation[[name]]$sha256 <- hash
  validation[[name]]$publication_metadata_update <- checks[[name]]
  pins[[name]] <- list(
    sha256 = hash,
    compared_cells = validation[[name]]$source_cells_compared,
    evidence = "validation-all.json plus additional-release-preparation-checks.json: all source-validated content unchanged except license status and publication metadata"
  )
  rm(x, old, y)
  gc()
}
write.table(
  m,
  "data-raw/_shared/metadata/noncptac/manifest.tsv",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE,
  na = ""
)
all <- read.delim("inst/extdata/manifest.tsv", stringsAsFactors = FALSE)
all$url[is.na(all$url)] <- ""
for (name in names) {
  all[all$dataset == name & all$kind == "curated", ] <- m[m$dataset == name, ]
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
  "data-raw/_shared/reports/noncptac/validation-all.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
jsonlite::write_json(
  pins,
  "data-raw/_shared/reports/noncptac/completed-source-checks.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
jsonlite::write_json(
  checks,
  "data-raw/_shared/reports/noncptac/additional-release-preparation-checks.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
