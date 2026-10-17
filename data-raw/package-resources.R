# Stage every curated dataset externally and generate the package manifest.
stopifnot(requireNamespace("glyexp", quietly = TRUE))
staging <- "data-raw/bundled-build"
assets <- "data-raw/releases/data-v0.1.0"
dir.create(assets, recursive = TRUE, showWarnings = FALSE)
records <- jsonlite::fromJSON(
  "data-raw/dataset-descriptions.json",
  simplifyVector = FALSE
)
entries <- list()
base_url <- "https://github.com/glycoverse/glyhub/releases/download/data-v0.1.0/"
for (record in records) {
  name <- record$name
  file <- file.path(staging, paste0(name, ".rda"))
  stopifnot(
    file.exists(file),
    file.copy(file, file.path(assets, basename(file)), overwrite = TRUE)
  )
  e <- new.env(parent = emptyenv())
  loaded <- load(file, envir = e)
  stopifnot(identical(loaded, name), methods::validObject(e[[name]]))
  entries[[length(entries) + 1L]] <- data.frame(
    dataset = name,
    source = "GlycoPOST",
    kind = "curated",
    format = "rda",
    storage = "release",
    filename = basename(file),
    bytes = file.info(file)$size,
    sha256 = digest::digest(file = file, algo = "sha256"),
    version = "data-v0.1.0",
    url = paste0(base_url, basename(file)),
    features = nrow(e[[name]]),
    measurements = ncol(e[[name]])
  )
}
cptac <- utils::read.delim(
  "data-raw/CPTAC/manifest.tsv",
  stringsAsFactors = FALSE
)
for (i in seq_len(nrow(cptac))) {
  x <- cptac[i, ]
  stopifnot(file.copy(
    file.path("data-raw/CPTAC/assets", x$filename),
    file.path(assets, x$filename),
    overwrite = TRUE
  ))
  entries[[length(entries) + 1L]] <- data.frame(
    dataset = x$dataset,
    source = "CPTAC",
    kind = x$kind,
    format = if (x$kind == "curated") "rds" else "tsv.gz",
    storage = "release",
    filename = x$filename,
    bytes = x$bytes,
    sha256 = x$sha256,
    version = "data-v0.1.0",
    url = paste0(base_url, x$filename),
    features = x$features,
    measurements = x$measurements
  )
}
manifest <- do.call(rbind, entries)
utils::write.table(
  manifest,
  "inst/extdata/manifest.tsv",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)
file.copy(
  "inst/extdata/manifest.tsv",
  file.path(assets, "manifest.tsv"),
  overwrite = TRUE
)
message(
  "Staged ",
  sum(manifest$kind == "curated"),
  " curated datasets and ",
  sum(manifest$kind == "raw"),
  " raw archives"
)
