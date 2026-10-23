args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
source("data-raw/_shared/scripts/noncptac/register-source.R")
for (spec in jsonlite::fromJSON("data-raw/MSV000097695/source-assets-additional.json", simplifyVector = FALSE)) {
 register_literature_source(file.path(args[1], spec$local_file), spec, args[2])
}
