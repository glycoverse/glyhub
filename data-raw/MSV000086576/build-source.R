# Exact author files only: no numeric transformation or curated SE construction.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
source("data-raw/_shared/scripts/noncptac/register-source.R")
specs <- jsonlite::fromJSON("data-raw/MSV000086576/source-assets.json", simplifyVector = FALSE)
for (spec in specs) {
  register_literature_source(file.path(args[1], spec$local_file), spec, args[2])
}
