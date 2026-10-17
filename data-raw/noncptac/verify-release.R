# Real cold-cache download verification of the existing release.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 1L, !dir.exists(args[1]))
options(timeout = 600)
devtools::load_all(quiet = TRUE)
decisions <- jsonlite::fromJSON("data-raw/noncptac/publication-decisions.json")
m <- subset(glyhub_catalog(), dataset %in% decisions$dataset[decisions$publish])
stopifnot(nrow(m) == 8L)
results <- list()
for (i in seq_len(nrow(m))) {
  e <- m[i, ]
  x <- glyhub_load(e$dataset, cache_dir = args[1])
  local <- readRDS(file.path("data-raw/noncptac/assets", e$filename))
  stopifnot(methods::validObject(x), identical(x, local))
  path <- file.path(args[1], e$version, paste0(e$sha256, "-", e$filename))
  stopifnot(
    file.info(path)$size == e$bytes,
    digest::digest(file = path, algo = "sha256") == e$sha256
  )
  results[[e$dataset]] <- list(
    url = e$url,
    bytes = e$bytes,
    sha256 = e$sha256,
    dimensions = dim(x),
    cold_download = TRUE,
    identical_to_source_validated_local_object = TRUE
  )
  jsonlite::write_json(
    results,
    "../evidence/noncptac-remote-validation.json",
    pretty = TRUE,
    auto_unbox = TRUE
  )
  cat(e$dataset, "cold download and source-validated object equality OK\n")
  rm(x, local)
  gc()
}
