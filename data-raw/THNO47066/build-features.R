args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source("data-raw/_shared/scripts/noncptac/register-literature.R")
source("data-raw/_shared/scripts/noncptac/convert-feature-source.R")
for (spec0 in jsonlite::fromJSON(
  "data-raw/THNO47066/feature-sources.json",
  simplifyVector = FALSE
)) {
  spec <- jsonlite::fromJSON(jsonlite::toJSON(
    spec0,
    auto_unbox = TRUE,
    null = "null"
  ))
  if (is.list(spec$read_range)) {
    spec$read_range <- NULL
  }
  path <- file.path(args[1], spec$local_file)
  stopifnot(identical(
    digest::digest(file = path, algo = "sha256"),
    spec$sha256
  ))
  x <- literature_feature_source(path, spec)
  stopifnot(methods::validObject(x))
  register_literature(
    x,
    spec$dataset,
    spec$title,
    c(spec$design, spec$molecular_level, spec$limitations)
  )
}
